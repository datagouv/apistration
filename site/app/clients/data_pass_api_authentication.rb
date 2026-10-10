# :nocov:
class DataPassAPIAuthentication < AbstractDataPassAPIClient
  def access_token
    http_connection.post(
      auth_url,
      URI.encode_www_form(
        grant_type: 'client_credentials',
        client_id:,
        client_secret:,
        scope: 'read_authorizations'
      ),
      'Content-Type' => 'application/x-www-form-urlencoded'
    ).body['access_token']
  end

  private

  def auth_url
    "#{DataPass::BASE_URL}/api/oauth/token"
  end
end
