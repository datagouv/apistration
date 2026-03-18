module SIADE::V3::Oauth2::AbstractTokenProvider
  class Error < ::StandardError; end
  extend Forwardable
  def_delegators :oauth_token, :expires_at, :expires_in, :token, :refresh_token

  def oauth_token
    token_from_redis || token_from_provider
  end

  private

  def token_from_redis
    redis_token_valid? ? redis_token : nil
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
    Redis.current.get(redis_key) || '{}'
  end

  def token_from_provider
    client.get_token(client_get_token_params, access_token_options)
      .tap(&method(:save_to_redis))
  rescue OAuth2::Error => e
    message = "Error while retrieving #{self.class.name} OAuth2 JSON token from provider (#{e.class} #{e.message}))"
    MonitoringService.instance.capture_message(message, level: 'warning')
    raise Error, e.message
  end

  def save_to_redis(token)
    Redis.current.set(redis_key, token.to_json)
  end

  def redis_key
    self
      .class
      .name
      .remove('TokenProvider')
      .underscore
      .to_sym
  end

  def client
    @client ||= OAuth2::Client.new(client_id, client_secret, client_options)
  end

  def client_get_token_params
    # Ref : https://rdoc.info/github/intridea/oauth2/OAuth2/Client#get_token-instance_method
    fail 'client_get_token_params has to be implemented'
  end

  def access_token_options
    # Ref : https://rdoc.info/github/intridea/oauth2/OAuth2/Client#get_token-instance_method
    fail 'access_token_options has to be implemented'
  end

  def client_options
    # Ref : https://rdoc.info/github/intridea/oauth2/OAuth2/Client#initialize-instance_method
    fail 'client_options has to be implemented'
  end

  def client_id
    # Ref : https://rdoc.info/github/intridea/oauth2/OAuth2/Client#initialize-instance_method
    fail 'client_id has to be implemented'
  end

  def client_secret
    # Ref : https://rdoc.info/github/intridea/oauth2/OAuth2/Client#initialize-instance_method
    fail 'client_secret has to be implemented'
  end
end
