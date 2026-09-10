class ConditionalCacheDelete
  COMPARE_AND_DELETE = <<~LUA.freeze
    if redis.call('get', KEYS[1]) == ARGV[1] then
      return redis.call('del', KEYS[1])
    end
    return 0
  LUA

  def self.call(key, **options, &predicate)
    cache = Rails.cache
    case cache
    when ActiveSupport::Cache::RedisCacheStore
      new(cache, key, options).delete(&predicate)
    when ActiveSupport::Cache::MemoryStore
      cache.synchronize { cache.delete(key, **options) if predicate.call(cache.read(key, **options)) }
    end
  end

  def initialize(cache, key, options)
    @cache = cache
    @options = cache.options.merge(options)
    @key = cache.send(:normalize_key, key, @options)
  end

  def delete
    @cache.send(:failsafe, :delete_entry, returning: false) do
      payload = @cache.redis.then { |redis| redis.get(@key) }
      entry = @cache.send(:deserialize_entry, payload, **@options)
      next false unless entry && yield(entry.value)

      @cache.redis.then { |redis| redis.eval(COMPARE_AND_DELETE, keys: [@key], argv: [payload]) == 1 }
    end
  end
end
