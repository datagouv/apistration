class QUALIBAT::CertificationsBatiment::Authenticate < AbstractGetToken
  def client_url
    [
      URI(Siade.credentials[:qualibat_api_url]),
      'token'
    ].join('/')
  end

  def access_token(response)
    JSON.parse(response.body)['access_token']
  end

  def expires_in(response)
    JSON.parse(response.body)['expires_in']
  end

  def extra_headers(request)
    request['Authorization'] = "Basic #{basic_auth}"
  end

  private

  def basic_auth
    Base64.strict_encode64("#{Siade.credentials[:qualibat_api_username]}:#{Siade.credentials[:qualibat_api_password]}")
  end
end
