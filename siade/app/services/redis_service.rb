class RedisService
  def dump(key, object)
    safe_run(:set, key, Marshal.dump(object))
  end

  # rubocop:disable Security/MarshalLoad
  def restore(key)
    return unless safe_run(:exists?, key)

    Marshal.restore(safe_run(:get, key))
  end
  # rubocop:enable Security/MarshalLoad

  %w[
    get
    exists?
    ttl
    del
  ].each do |mth|
    define_method(mth) do |*args|
      safe_run(mth, *args)
    end
  end

  # rubocop:disable Naming/MethodParameterName
  def set(key, value, ex: nil)
    redis.set(key, value, ex:)
  rescue *redis_errors
    nil
  end
  # rubocop:enable Naming/MethodParameterName

  def self.redis_options
    AppConfig.config_for(:redis)
  end

  private

  def safe_run(command, *)
    redis.send(command, *)
  rescue *redis_errors
    nil
  end

  def redis
    @redis ||= Redis.new(redis_options)
  end

  def redis_options
    self.class.redis_options
  end

  def redis_errors
    [
      Redis::BaseConnectionError,
      Errno::ECONNREFUSED,
      Redis::CommandError,
      RedisClient::ReadTimeoutError
    ]
  end
end
