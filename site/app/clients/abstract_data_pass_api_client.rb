require 'faraday'

class AbstractDataPassAPIClient
  protected

  def http_connection(&block)
    Faraday.new do |conn|
      conn.request :retry, max: 5
      conn.response :raise_error
      conn.response :json
      conn.options.timeout = 2
      yield(conn) if block
    end
  end

  def client_id
    AdminApientreprise.credentials[:datapass_client_id]
  end

  def client_secret
    AdminApientreprise.credentials[:datapass_client_secret]
  end
end
