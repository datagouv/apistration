class RedisService
  include Singleton
  extend Forwardable

  attr_reader :redis

  def initialize
    @redis = Redis.new(url:)
  end

  def url
    ENV.fetch('REDIS_DATABASE_URL', 'redis://localhost:6379/0')
  end

  def_delegators :redis,
    :get,
    :set,
    :ttl
end
