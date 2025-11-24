class INSEE::Authenticate < AbstractGetToken
  protected

  def client_url
    Siade.credentials[:insee_oauth_url]
  end

  def access_token(response)
    JSON.parse(response.body)['access_token']
  end

  def expires_in(response)
    JSON.parse(response.body)['expires_in']
  end

  private

  def form_data
    {
      client_id:,
      client_secret:,
      grant_type: 'password',
      username:,
      password:
    }
  end

  def client_id
    Siade.credentials[:insee_sirene_client_id]
  end

  def client_secret
    Siade.credentials[:insee_sirene_client_secret]
  end

  def username
    Siade.credentials[:insee_apim_username]
  end

  def password
    Siade.credentials[:insee_apim_password]
  end
end
