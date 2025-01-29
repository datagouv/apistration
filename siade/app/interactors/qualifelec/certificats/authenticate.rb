class Qualifelec::Certificats::Authenticate < AbstractGetToken
  protected

  def client_url
    URI(Siade.credentials[:qualifelec_auth_url])
  end

  def expires_in(response)
    token = access_token(response)

    expires_at = decoded_jwt(token).first['exp']

    expires_at - Time.zone.now.to_i
  end

  def decoded_jwt(token)
    JWT.decode(token, nil, false, { algorithm: 'RS256' })
  end

  def access_token(response)
    JSON.parse(response.body)['token']
  end

  def request_params
    {
      username: qualifelec_username,
      password: qualifelec_password
    }
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['accept'] = 'application/json'
  end

  private

  def qualifelec_username
    Siade.credentials[:qualifelec_username]
  end

  def qualifelec_password
    Siade.credentials[:qualifelec_password]
  end
end
