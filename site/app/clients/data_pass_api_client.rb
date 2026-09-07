# :nocov:
class DataPassAPIClient < AbstractDataPassAPIClient
  def definitions(api)
    http_connection.get("#{DataPass::BASE_URL}/api/v1/definitions/#{api}").body
  end

  protected

  def http_connection
    super do |conn|
      conn.request :authorization, 'Bearer', -> { DataPassAPIAuthentication.new.access_token }
    end
  end
end
