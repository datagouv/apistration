class INSEEAPIAuthentication
  class TemporaryError < StandardError; end
  class AuthenticationError < StandardError; end

  Attempt = Data.define(:status, :token, :expires_in)

  OAUTH_URL = 'https://auth.insee.net/auth/realms/apim-gravitee/protocol/openid-connect/token'.freeze
  CACHE_NAMESPACE = 'insee'.freeze
  TOKEN_CACHE_KEY = 'authenticate'.freeze
  LOCK_CACHE_KEY = 'auth_lock'.freeze
  FAILURE_CACHE_KEY = 'auth_failed'.freeze
  LOCK_TTL = 30.seconds
  LOCK_WAIT = 0.5
  FAILURE_TTL = 30.minutes
  TOKEN_EXPIRATION_MARGIN = 10
  TIMEOUT = 5
  INVALID_GRANT_HTTP_STATUSES = [400, 401].freeze

  def access_token
    cached_token || authenticate!
  end

  def attempt(password)
    response = post_credentials(password)
    payload = parsed_body(response)

    return granted_attempt(payload) if granted?(response, payload)
    return Attempt.new(status: :invalid_grant, token: nil, expires_in: nil) if invalid_grant?(response, payload)

    unavailable_attempt
  rescue Faraday::Error
    unavailable_attempt
  end

  def recently_failed?
    cache_read(FAILURE_CACHE_KEY).present?
  end

  private

  def authenticate!
    raise TemporaryError, 'INSEE authentication recently failed on every candidate' if recently_failed?

    return token_from_concurrent_authentication unless acquire_lock!

    begin
      cached_token || token_from_candidates
    ensure
      release_lock!
    end
  end

  def token_from_concurrent_authentication
    sleep(LOCK_WAIT)

    cached_token || raise(TemporaryError, 'another INSEE authentication is already in flight')
  end

  def token_from_candidates
    INSEE::PasswordDerivation.candidates.each do |candidate|
      result = attempt(candidate)

      return store_token(result) if result.status == :granted

      raise TemporaryError, 'INSEE OAuth is unavailable' unless result.status == :invalid_grant
    end

    fail_on_every_candidate_rejected!
  end

  def post_credentials(password)
    http_connection.post(
      OAUTH_URL,
      {
        'grant_type' => 'password',
        'client_id' => AdminApientreprise.credentials[:insee_client_id],
        'client_secret' => AdminApientreprise.credentials[:insee_client_secret],
        'username' => AdminApientreprise.credentials[:insee_username],
        'password' => password
      }.to_query
    )
  end

  def granted?(response, payload)
    response.status == 200 && payload['access_token'].present?
  end

  def invalid_grant?(response, payload)
    INVALID_GRANT_HTTP_STATUSES.include?(response.status) && payload['error'] == 'invalid_grant'
  end

  def granted_attempt(payload)
    Attempt.new(status: :granted, token: payload['access_token'], expires_in: payload['expires_in'])
  end

  def unavailable_attempt
    Attempt.new(status: :unavailable, token: nil, expires_in: nil)
  end

  def parsed_body(response)
    JSON.parse(response.body.to_s)
  rescue JSON::ParserError
    {}
  end

  def store_token(attempt)
    cache_write(
      TOKEN_CACHE_KEY,
      attempt.token,
      expires_in: [attempt.expires_in.to_i - TOKEN_EXPIRATION_MARGIN, 1].max
    )

    attempt.token
  end

  def cached_token
    cache_read(TOKEN_CACHE_KEY)
  end

  def acquire_lock!
    @lock_owner = SecureRandom.uuid

    cache_write(LOCK_CACHE_KEY, @lock_owner, expires_in: LOCK_TTL, unless_exist: true)
  end

  def release_lock!
    return unless cache_read(LOCK_CACHE_KEY) == @lock_owner

    Rails.cache.delete(LOCK_CACHE_KEY, namespace: CACHE_NAMESPACE)
  end

  def cache_read(key)
    Rails.cache.read(key, namespace: CACHE_NAMESPACE)
  end

  def cache_write(key, value, expires_in:, unless_exist: false)
    Rails.cache.write(key, value, namespace: CACHE_NAMESPACE, expires_in:, unless_exist:)
  end

  def fail_on_every_candidate_rejected!
    cache_write(FAILURE_CACHE_KEY, true, expires_in: FAILURE_TTL)

    MonitoringService.instance.track(
      'INSEE authentication failed on every candidate: password desynchronized or account locked',
      level: :error,
      context: {
        period: INSEE::PasswordDerivation.current_period,
        bypassed: INSEE::PasswordDerivation.bypassed?,
        candidates_count: INSEE::PasswordDerivation.candidates.size
      }
    )

    raise AuthenticationError, 'INSEE rejected every password candidate'
  end

  def http_connection
    @http_connection ||= Faraday.new do |conn|
      conn.options.timeout = TIMEOUT
      conn.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    end
  end
end
