class GetOAuth2Token < ApplicationInteractor
  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end
    end
  end

  extend Forwardable

  def call
    context.token = oauth_token.token
  end

  private

  # @see https://rdoc.info/github/intridea/oauth2/OAuth2/Client#get_token-instance_method
  def client_get_token_params
    fail NotImplementedError
  end

  # @see https://rdoc.info/github/intridea/oauth2/OAuth2/Client#get_token-instance_method
  def access_token_options
    fail NotImplementedError
  end

  # @see https://rdoc.info/github/intridea/oauth2/OAuth2/Client#initialize-instance_method
  def client_options
    fail NotImplementedError
  end

  # @see https://rdoc.info/github/intridea/oauth2/OAuth2/Client#initialize-instance_method
  def client_id
    fail NotImplementedError
  end

  # @see https://rdoc.info/github/intridea/oauth2/OAuth2/Client#initialize-instance_method
  def client_secret
    fail NotImplementedError
  end

  def oauth_token
    token_from_redis || token_from_provider
  end

  def token_from_redis
    redis_token if redis_token_valid?
  end

  def redis_token_valid?
    redis_token.expires? && !redis_token.expired?
  end

  def redis_token
    @redis_token ||= OAuth2::AccessToken
      .from_hash(
        client,
        redis_json_token
      )
  end

  def redis_json_token
    JSON.parse(redis_access_token_property_values_string)
  rescue JSON::ParserError => e
    message = "Error while parsing #{self.class.name} OAuth2 JSON token from Redis (#{e.class} #{e.message})"

    MonitoringService.instance.capture_message(message, level: 'warning')
    {}
  end

  def redis_access_token_property_values_string
    RedisService.instance.get(redis_key) || '{}'
  end

  # rubocop:disable Metrics/MethodLength
  def token_from_provider
    client.get_token(client_get_token_params, access_token_options)
      .tap(&method(:save_to_redis))
  rescue OAuth2::Error => e
    message = "Error while retrieving #{self.class.name} OAuth2 JSON token from provider (#{e.class} #{e.message}))"

    MonitoringService.instance.capture_message(message, level: 'warning')

    context.errors << ProviderAuthenticationError.new(context.provider_name, message)
    context.fail!
  rescue Net::OpenTimeout, Net::ReadTimeout, EOFError
    context.errors << ProviderTimeoutError.new(context.provider_name)
    context.fail!
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH
    context.errors << ProviderUnavailable.new(context.provider_name)
    context.fail!
  rescue Errno::ENETUNREACH
    context.errors << NetworkError.new
    context.fail!
  end
  # rubocop:enable Metrics/MethodLength

  def save_to_redis(token)
    RedisService.instance.set(redis_key, token.to_json)
  end

  def redis_key
    self
      .class
      .name
      .underscore
      .to_sym
  end

  def client
    @client ||= OAuth2::Client.new(client_id, client_secret, client_options)
  end
end
