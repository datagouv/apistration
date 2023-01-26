class RedisService
  include Singleton
  extend Forwardable

  attr_reader :redis

  def initialize
    @redis = Redis.new(redis_options)
  end

  def redis_options
    Rails.application.config_for(:redis)
  end

  def dump(key, object)
    redis.set(key, Marshal.dump(object))
  end

  # rubocop:disable Security/MarshalLoad
  def restore(key)
    return unless redis.exists?(key)

    Marshal.restore(redis.get(key))
  end
  # rubocop:enable Security/MarshalLoad

  def_delegators :redis,
    :get,
    :exists?,
    :set,
    :ttl
end
