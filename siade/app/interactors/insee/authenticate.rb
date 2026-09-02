class INSEE::Authenticate < MakeRequest::Post
  CACHE_KEY = :'insee/authenticate'
  GUARD_CACHE_NAMESPACE = 'insee'.freeze
  LOCK_CACHE_KEY = 'auth_lock'.freeze
  FAILURE_CACHE_KEY = 'auth_failed'.freeze
  LOCK_TTL = 60.seconds
  LOCK_WAIT = 0.5
  FAILURE_TTL = 30.minutes
  TOKEN_EXPIRATION_MARGIN = 10
  INVALID_GRANT_HTTP_CODES = [400, 401].freeze

  def self.invalidate_token_cache!
    EncryptedCache.write(CACHE_KEY, nil)
  end

  def self.clear_guards!
    [LOCK_CACHE_KEY, FAILURE_CACHE_KEY].each do |key|
      Rails.cache.delete(key, namespace: GUARD_CACHE_NAMESPACE)
    end
  end

  def call
    return if use_mocked_data?

    context.token = cached_token || authenticate!
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

    return token_from_concurrent_authentication unless acquire_lock!

    begin
      cached_token || token_from_candidates
    ensure
      release_lock!
    end
  end

  def token_from_concurrent_authentication
    sleep(LOCK_WAIT)

    cached_token || fail_with_temporary_error!
  end

  def token_from_candidates
    INSEE::PasswordDerivation.candidates.each do |candidate|
      @password = candidate

      response = api_call_with_error_handling
      payload = parsed_body(response)

      return store_token(payload) if token_granted?(response, payload)

      fail_with_temporary_error! unless invalid_grant?(response, payload)
    end

    fail_with_authentication_error!
  end

  def token_granted?(response, payload)
    response.code.to_i == 200 && payload['access_token'].present?
  end

  def invalid_grant?(response, payload)
    INVALID_GRANT_HTTP_CODES.include?(response.code.to_i) &&
      payload['error'] == 'invalid_grant'
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

  def cached_token
    EncryptedCache.read(CACHE_KEY)
  end

  def recently_failed?
    guard_read(FAILURE_CACHE_KEY).present?
  end

  def acquire_lock!
    @lock_owner = SecureRandom.uuid

    guard_write(LOCK_CACHE_KEY, @lock_owner, expires_in: LOCK_TTL, unless_exist: true)
  end

  def release_lock!
    return unless guard_read(LOCK_CACHE_KEY) == @lock_owner

    Rails.cache.delete(LOCK_CACHE_KEY, namespace: GUARD_CACHE_NAMESPACE)
  end

  def guard_read(key)
    Rails.cache.read(key, namespace: GUARD_CACHE_NAMESPACE)
  end

  def guard_write(key, value, expires_in:, unless_exist: false)
    Rails.cache.write(key, value, namespace: GUARD_CACHE_NAMESPACE, expires_in:, unless_exist:)
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

  def fail_with_authentication_error!
    guard_write(FAILURE_CACHE_KEY, true, expires_in: FAILURE_TTL)

    track_all_candidates_rejected!

    context.errors << ProviderAuthenticationError.new(context.provider_name)
    context.fail!
  end

  def track_all_candidates_rejected!
    MonitoringService.instance.track_with_added_context(
      'error',
      'INSEE authentication failed on every candidate: password desynchronized or account locked',
      {
        period: INSEE::PasswordDerivation.current_period,
        bypassed: INSEE::PasswordDerivation.bypassed?,
        candidates_count: INSEE::PasswordDerivation.candidates.size
      }
    )
  end
end
