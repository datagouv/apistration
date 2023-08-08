class Qualifelec::Certificats::Authenticate < AbstractGetToken
  protected

  def client_url
    URI(Siade.credentials[:qualifelec_auth_url])
  end

  def expires_in(_response)
    3600
  end

  def access_token(response)
    JSON.parse(response.body)['token']
  end

  def form_data
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
