require 'faraday'

class DatapassAPIAuthentication
  CACHE_KEY = 'datapass_api_access_token'.freeze
  SCOPES = 'read_authorizations'.freeze
  EXPIRATION_MARGIN = 60.seconds

  def self.invalidate_token_cache!
    Rails.cache.delete(CACHE_KEY)
  end

  def access_token
    Rails.cache.read(CACHE_KEY) || request_and_cache_access_token
  end

  private

  def request_and_cache_access_token
    token = request_token
    lifetime = token['expires_in'].to_i.seconds - EXPIRATION_MARGIN

    Rails.cache.write(CACHE_KEY, token['access_token'], expires_in: lifetime) if lifetime.positive?

    token['access_token']
  end

  def request_token
    http_connection.post(
      'oauth/token',
      grant_type: 'client_credentials',
      client_id: credentials[:client_id],
      client_secret: credentials[:client_secret],
      scope: SCOPES
    ).body
  rescue Faraday::ClientError => e
    raise DatapassAPIClient::Unauthorized.new(e.message, status: e.response_status)
  end

  def credentials
    AdminApientreprise.credentials[:datapass_api]
  end

  def http_connection
    Faraday.new(url: credentials[:url]) do |conn|
      conn.request :url_encoded
      conn.response :raise_error
      conn.response :json
      conn.options.timeout = 5
    end
  end
end
