class INSEEAPIAuthentication
  class TemporaryError < StandardError; end
  class AuthenticationError < StandardError; end

  CACHE_NAMESPACE = 'insee'.freeze
  TOKEN_CACHE_KEY = 'authenticate'.freeze
  LOCK_CACHE_KEY = 'auth_lock'.freeze
  FAILURE_CACHE_KEY = 'auth_failed'.freeze
  LOCK_TTL = 30.seconds
  LOCK_WAIT = 0.5
  FAILURE_TTL = 30.minutes
  TOKEN_EXPIRATION_MARGIN = 10
  HELD_BACK_MESSAGE = 'INSEE authentication recently failed on every candidate'.freeze
  REFUSED_EXCHANGE_MESSAGE = 'INSEE refused the OAuth exchange itself: client credentials revoked or account locked'.freeze
  EVERY_CANDIDATE_MESSAGE = 'INSEE authentication failed on every candidate: password desynchronized or account locked'.freeze

  def self.invalidate_token_cache!(rejected_token)
    return unless published_token == rejected_token

    Rails.cache.delete(TOKEN_CACHE_KEY, namespace: CACHE_NAMESPACE)
  end

  def self.published_token
    outside_the_request_cache { Rails.cache.read(TOKEN_CACHE_KEY, namespace: CACHE_NAMESPACE) }
  end

  def self.outside_the_request_cache(&)
    Rails.cache.with_local_cache(&)
  end

  def self.clear_guards!
    [LOCK_CACHE_KEY, FAILURE_CACHE_KEY].each do |key|
      Rails.cache.delete(key, namespace: CACHE_NAMESPACE)
    end
  end

  delegate :attempt, to: :exchange
  delegate :published_token, :outside_the_request_cache, to: :class, private: true

  def access_token
    published_token || authenticate!
  end

  def recently_failed?
    cache_read(FAILURE_CACHE_KEY).present?
  end

  def record_authentication_failure!(message)
    cache_write(FAILURE_CACHE_KEY, true, expires_in: FAILURE_TTL)

    MonitoringService.instance.track(
      message,
      level: :error,
      context: {
        period: INSEE::PasswordDerivation.current_period,
        bypassed: INSEE::PasswordDerivation.bypassed?,
        candidates_count: INSEE::PasswordDerivation.candidates.size
      }
    )
  end

  private

  def authenticate!
    raise TemporaryError, HELD_BACK_MESSAGE if recently_failed?

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

    published_token || raise(TemporaryError, 'another INSEE authentication is already in flight')
  end

  def token_from_candidates
    raise TemporaryError, HELD_BACK_MESSAGE if recently_failed?

    candidates = INSEE::PasswordDerivation.candidates
    token = token_from(candidates)
    return token if token

    current_password = INSEE::PasswordDerivation.current_password
    token = token_from([current_password]) unless candidates.last == current_password

    token || fail_on_rejection!(EVERY_CANDIDATE_MESSAGE, 'INSEE rejected every password candidate')
  end

  def token_from(candidates)
    candidates.each do |candidate|
      result = attempt(candidate)

      return store_token(result) if result.status == :granted
      next if result.status == :invalid_grant

      fail_on_rejection!(REFUSED_EXCHANGE_MESSAGE, 'INSEE refused the OAuth exchange') if result.status == :rejected
      raise TemporaryError, 'INSEE OAuth is unavailable'
    end

    nil
  end

  def store_token(attempt)
    cache_write(
      TOKEN_CACHE_KEY,
      attempt.token,
      expires_in: [attempt.expires_in.to_i - TOKEN_EXPIRATION_MARGIN, 1].max
    )

    attempt.token
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
    outside_the_request_cache { Rails.cache.read(key, namespace: CACHE_NAMESPACE) }
  end

  def cache_write(key, value, expires_in:, unless_exist: false)
    Rails.cache.write(key, value, namespace: CACHE_NAMESPACE, expires_in:, unless_exist:)
  end

  def fail_on_rejection!(alert, error)
    record_authentication_failure!(alert)

    raise AuthenticationError, error
  end

  def exchange
    @exchange ||= INSEEOAuthExchange.new
  end
end
