class INSEE::Authenticate < MakeRequest::Post
  raises ProviderAuthenticationError

  CACHE_KEY = :'insee/authenticate'
  LOCK_CACHE_KEY = 'auth_lock'.freeze
  LOCK_TTL = 90.seconds
  LOCK_WAIT = 0.5
  TOKEN_EXPIRATION_MARGIN = 10
  INVALID_GRANT_HTTP_CODES = [400, 401].freeze
  TRANSIENT_HTTP_CODES = [408, 429].freeze

  delegate :published_token, :outside_the_request_cache, to: :class, private: true

  def self.invalidate_token_cache!(rejected_token)
    EncryptedCache.delete_if_value(CACHE_KEY, rejected_token)
  end

  def self.published_token
    outside_the_request_cache { EncryptedCache.read(CACHE_KEY) }
  end

  def self.outside_the_request_cache(&)
    Rails.cache.with_local_cache(&)
  end

  def self.clear_guards!
    Rails.cache.delete(LOCK_CACHE_KEY)
    INSEE::AuthenticationBackoff.clear!
    INSEE::AcceptedPassword.forget!
  end

  def call
    return if use_mocked_data?

    context.token = context.ahead_of_expiry ? renew_ahead_of_expiry! : (current_token || authenticate!)
  end

  protected

  def request_uri
    URI(Siade.credentials[:insee_oauth_url])
  end

  def form_data
    {
      client_id: Siade.credentials[:insee_sirene_client_id],
      client_secret: Siade.credentials[:insee_sirene_client_secret],
      grant_type: 'password',
      username: Siade.credentials[:insee_apim_username],
      password: @password
    }
  end

  private

  def current_token
    token = published_token
    return token unless token && renewal_due?

    renewed_ahead_of_expiry || token
  end

  def renewed_ahead_of_expiry
    renewal = self.class.call(provider_name: context.provider_name, ahead_of_expiry: true)

    renewal.token if renewal.success?
  end

  def renew_ahead_of_expiry!
    fail_with_temporary_error! if recently_failed?
    fail_with_temporary_error! unless acquire_lock! == true

    begin
      return published_token unless renewal_due?

      INSEE::TokenRenewal.postpone!
      token_from_candidates
    ensure
      release_lock!
    end
  end

  def renewal_due?
    INSEE::TokenRenewal.due? { password_attempts.size }
  end

  def authenticate!
    fail_with_temporary_error! if recently_failed?

    case acquire_lock!
    when true then token_under_lock
    when false then token_from_concurrent_authentication
    else token_from_candidates
    end
  end

  def token_under_lock
    published_token || token_from_candidates
  ensure
    release_lock!
  end

  def token_from_concurrent_authentication
    sleep(LOCK_WAIT)

    published_token || fail_with_temporary_error!
  end

  def token_from_candidates
    fail_with_temporary_error! if recently_failed?

    @attempts = password_attempts

    token_from(@attempts) || fail_with_authentication_error!
  end

  def password_attempts
    candidates = INSEE::PasswordDerivation.candidates
    current_password = INSEE::PasswordDerivation.current_password

    return [current_password] if !INSEE::PasswordDerivation.bypassed? && INSEE::AcceptedPassword.last?(current_password)

    candidates.last == current_password ? candidates : [*candidates, current_password]
  end

  def token_from(candidates)
    candidates.each do |candidate|
      @password = candidate

      response = api_call_with_error_handling
      payload = parsed_body(response)

      return store_token(payload) if token_granted?(response, payload)

      @refusal = INSEE::GrantRefusal.new(response, payload)

      fail_with_temporary_error! if transient?(response)
      next if invalid_grant?(response, payload)

      fail_with_oauth_rejection! if client_error?(response)
      fail_with_temporary_error!
    end

    nil
  end

  def token_granted?(response, payload)
    response.code.to_i == 200 && payload['access_token'].present?
  end

  def invalid_grant?(response, payload)
    INVALID_GRANT_HTTP_CODES.include?(response.code.to_i) &&
      payload['error'] == 'invalid_grant'
  end

  def transient?(response)
    TRANSIENT_HTTP_CODES.include?(response.code.to_i)
  end

  def client_error?(response)
    response.code.to_i.between?(400, 499)
  end

  def parsed_body(response)
    JSON.parse(response.body.to_s)
  rescue JSON::ParserError
    {}
  end

  def store_token(payload)
    token = payload['access_token']
    lifetime = payload['expires_in'].to_i

    report_recovery(INSEE::AuthenticationBackoff.end_episode!)
    INSEE::AcceptedPassword.remember!(@password)

    expires_in = [lifetime - TOKEN_EXPIRATION_MARGIN, 1].max

    return token unless EncryptedCache.write(CACHE_KEY, token, expires_in:)

    INSEE::TokenRenewal.schedule!(lifetime:, expires_in:)

    token
  end

  def recently_failed?
    INSEE::AuthenticationBackoff.holding_back?
  end

  def acquire_lock!
    @lock_owner = SecureRandom.uuid

    Rails.cache.write(LOCK_CACHE_KEY, @lock_owner, expires_in: LOCK_TTL, unless_exist: true)
  end

  def release_lock!
    ConditionalCacheDelete.call(LOCK_CACHE_KEY) { |owner| owner == @lock_owner }
  end

  def fail_with_temporary_error!
    error = ProviderTemporaryError.new(
      context.provider_name,
      "Erreur d'authentification temporaire auprès de l'INSEE, merci de réessayer votre appel"
    )
    error.add_meta(retry_in: 10)

    context.errors << error
    context.fail!
  end

  def fail_with_oauth_rejection!
    refusals = INSEE::AuthenticationBackoff.hold_back_after_oauth_rejection!

    track_authentication_failure!(
      'INSEE refused the OAuth exchange itself: client credentials revoked or account locked',
      refusals
    )

    fail_with_provider_authentication_error!
  end

  def fail_with_authentication_error!
    refusals = INSEE::AuthenticationBackoff.hold_back_after_refusal!
    track_authentication_failure!(refused_candidates_message, refusals) if refusals == 1

    fail_with_provider_authentication_error!
  end

  def refused_candidates_message
    if INSEE::PasswordDerivation.candidates.one?
      'INSEE refused the only password candidate: intermittent refusal or account locked'
    elsif @attempts.one?
      'INSEE refused the current password it accepted last: intermittent refusal, account locked or password changed outside the rotation'
    else
      'INSEE authentication failed on every candidate: password desynchronized or account locked'
    end
  end

  def fail_with_provider_authentication_error!
    context.errors << ProviderAuthenticationError.new(context.provider_name)
    context.fail!
  end

  def track_authentication_failure!(message, refusals)
    MonitoringService.instance.track_with_added_context(
      'error',
      message,
      {
        period: INSEE::PasswordDerivation.current_period,
        bypassed: INSEE::PasswordDerivation.bypassed?,
        candidates_count: INSEE::PasswordDerivation.candidates.size,
        attempts_count: @attempts.size,
        refusals:
      }.merge(@refusal.to_h)
    )
  end

  def report_recovery(episode)
    return if episode.nil?

    MonitoringService.instance.track_with_added_context(
      'warning',
      'INSEE authentication recovered',
      { refusals: episode.refusals, outage_seconds: episode.outage_seconds }
    )
  end
end
