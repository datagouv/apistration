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

  def_delegators :redis,
    :get,
    :exists?,
    :set,
    :ttl
end
