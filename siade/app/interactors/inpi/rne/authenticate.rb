require 'jwt'

class INPI::RNE::Authenticate < AbstractGetToken
  protected

  def request_params
    {
      username:,
      password:
    }
  end

  def client_url
    Siade.credentials[:inpi_rne_login_url]
  end

  def access_token(response)
    JSON.parse(response.body)['token']
  end

  def expires_in(response)
    token = access_token(response)

    JWT.decode(token, nil, false)[0]['exp'] - Time.now.to_i
  end

  def username
    context.inpi_rne_login_username.presence || Siade.credentials[:inpi_rne_login_username]
  end

  def password
    context.inpi_rne_login_password.presence || Siade.credentials[:inpi_rne_login_password]
  end
end
