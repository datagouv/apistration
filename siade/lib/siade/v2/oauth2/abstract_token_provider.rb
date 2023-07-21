module SIADE::V2::OAuth2::AbstractTokenProvider
  class Error < ::StandardError; end
  extend Forwardable
  def_delegators :oauth_token, :expires_at, :expires_in, :token, :refresh_token

  def oauth_token
    token_from_cache || token_from_provider
  end

  private

  def token_from_cache
    cache_token_valid? ? cache_token : nil
  end

  def cache_token_valid?
    cache_token.expires? && !cache_token.expired?
  end

  def cache_token
    @cache_token ||= OAuth2::AccessToken
      .from_hash(
        client,
        json_from_cache
      )
  end

  def json_from_cache
    JSON.parse(cache_json_access_token)
  rescue JSON::ParserError => e
    message = "Error while parsing #{self.class.name} OAuth2 JSON token from cache (#{e.class} #{e.message})"
    MonitoringService.instance.capture_message(message, level: 'warning')
    {}
  end

  def cache_json_access_token
    EncryptedCache.read(cache_key) || '{}'
  end

  def token_from_provider
    client.get_token(client_get_token_params, access_token_options)
      .tap(&method(:save_to_cache))
  rescue OAuth2::ConnectionError, OAuth2::Error, Errno::ECONNRESET, Net::OpenTimeout, Net::ReadTimeout => e
    track_error_from_provider(e)

    raise Error, e.message
  end

  def save_to_cache(token)
    EncryptedCache.write(cache_key, token.to_json)
  end

  def cache_key
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

  def track_error_from_provider(exception)
    MonitoringService.instance.track(
      :warn,
      "Error while retrieving #{self.class.name} OAuth2 JSON token from provider",
      {
        exception: {
          class: exception.class.to_s,
          message: exception.message
        }
      }
    )
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
