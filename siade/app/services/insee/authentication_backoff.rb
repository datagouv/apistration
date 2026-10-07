class INSEE::AuthenticationBackoff
  CACHE_NAMESPACE = 'insee'.freeze
  HOLD_CACHE_KEY = 'auth_failed'.freeze
  EPISODE_CACHE_KEY = 'auth_refusal_episode'.freeze
  STEPS = [30.seconds, 1.minute, 2.minutes, 4.minutes, 5.minutes].freeze
  OAUTH_REJECTION_HOLD = 30.minutes
  EPISODE_TTL = 1.hour

  Episode = Data.define(:refusals, :started_at) do
    def outage_seconds
      (Time.current - started_at).round
    end
  end

  def self.holding_back?
    read(HOLD_CACHE_KEY).present?
  end

  def self.hold_back_after_refusal!
    record_refusal!.tap { |refusals| hold_back!(STEPS[refusals.clamp(1, STEPS.size) - 1]) }
  end

  def self.hold_back_after_oauth_rejection!
    record_refusal!.tap { hold_back!(OAUTH_REJECTION_HOLD) }
  end

  def self.end_episode!
    episode = read(EPISODE_CACHE_KEY)
    return unless episode && Rails.cache.delete(EPISODE_CACHE_KEY, namespace: CACHE_NAMESPACE)

    Episode.new(**episode)
  end

  def self.clear!
    Rails.cache.delete(HOLD_CACHE_KEY, namespace: CACHE_NAMESPACE)
    Rails.cache.delete(EPISODE_CACHE_KEY, namespace: CACHE_NAMESPACE)
  end

  def self.record_refusal!
    episode = read(EPISODE_CACHE_KEY) || { refusals: 0, started_at: Time.current }
    episode = episode.merge(refusals: episode[:refusals] + 1)

    Rails.cache.write(EPISODE_CACHE_KEY, episode, namespace: CACHE_NAMESPACE, expires_in: EPISODE_TTL)

    episode[:refusals]
  end

  def self.hold_back!(duration)
    Rails.cache.write(HOLD_CACHE_KEY, true, namespace: CACHE_NAMESPACE, expires_in: duration)
  end

  def self.read(key)
    Rails.cache.with_local_cache { Rails.cache.read(key, namespace: CACHE_NAMESPACE) }
  end

  private_class_method :record_refusal!, :hold_back!, :read
end
