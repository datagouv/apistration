class RedisService
  def dump(key, object)
    redis.set(key, Marshal.dump(object))
  end

  # rubocop:disable Security/MarshalLoad
  def restore(key)
    return unless redis.exists?(key)

    Marshal.restore(redis.get(key))
  end
  # rubocop:enable Security/MarshalLoad

  %w[
    get
    exists?
    set
    ttl
    del
  ].each do |mth|
    define_method(mth) do |*args|
      redis.send(mth, *args)
    end
  end

  private

  def redis
    @redis ||= Redis.new(redis_options)
  end

  def redis_options
    Rails.application.config_for(:redis)
  end
end
