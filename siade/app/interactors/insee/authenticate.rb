class INSEE::Authenticate < MakeRequest::Post
  raises ProviderAuthenticationError

  CACHE_KEY = :'insee/authenticate'
  GUARD_CACHE_NAMESPACE = 'insee'.freeze
  LOCK_CACHE_KEY = 'auth_lock'.freeze
  FAILURE_CACHE_KEY = 'auth_failed'.freeze
  LOCK_TTL = 90.seconds
  LOCK_WAIT = 0.5
  FAILURE_TTL = 30.minutes
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
    Rails.cache.delete(FAILURE_CACHE_KEY, namespace: GUARD_CACHE_NAMESPACE)
  end

  def call
    return if use_mocked_data?

    context.token = published_token || authenticate!
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

    candidates = INSEE::PasswordDerivation.candidates
    token = token_from(candidates)
    return token if token

    current_password = INSEE::PasswordDerivation.current_password
    token = token_from([current_password]) unless candidates.last == current_password

    token || fail_with_authentication_error!
  end

  def token_from(candidates)
    candidates.each do |candidate|
      @password = candidate

      response = api_call_with_error_handling
      payload = parsed_body(response)

      return store_token(payload) if token_granted?(response, payload)

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

    EncryptedCache.write(
      CACHE_KEY,
      token,
      expires_in: [payload['expires_in'].to_i - TOKEN_EXPIRATION_MARGIN, 1].max
    )

    token
  end

  def recently_failed?
    outside_the_request_cache { Rails.cache.read(FAILURE_CACHE_KEY, namespace: GUARD_CACHE_NAMESPACE) }.present?
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
    record_authentication_failure!(
      'INSEE refused the OAuth exchange itself: client credentials revoked or account locked'
    )
  end

  def fail_with_authentication_error!
    record_authentication_failure!(
      'INSEE authentication failed on every candidate: password desynchronized or account locked'
    )
  end

  def record_authentication_failure!(message)
    Rails.cache.write(FAILURE_CACHE_KEY, true, namespace: GUARD_CACHE_NAMESPACE, expires_in: FAILURE_TTL)

    track_authentication_failure!(message)

    context.errors << ProviderAuthenticationError.new(context.provider_name)
    context.fail!
  end

  def track_authentication_failure!(message)
    MonitoringService.instance.track_with_added_context(
      'error',
      message,
      {
        period: INSEE::PasswordDerivation.current_period,
        bypassed: INSEE::PasswordDerivation.bypassed?,
        candidates_count: INSEE::PasswordDerivation.candidates.size
      }
    )
  end
end
