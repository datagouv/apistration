class DataSubvention::Subventions::Authenticate < AbstractGetToken
  private

  def extra_headers(request)
    request['accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
  end

  def access_token(response)
    JSON.parse(response.body).dig('user', 'jwt', 'token')
  end

  def expires_in(response)
    expiration_date = JSON.parse(response.body).dig('user', 'jwt', 'expirateDate')

    Time.zone.parse(expiration_date.to_s).to_i - Time.now.to_i
  end

  def client_url
    "#{Siade.credentials[:data_subvention_url]}/auth/login"
  end

  def request_params
    {
      email: Siade.credentials[:data_subvention_email],
      password: Siade.credentials[:data_subvention_password]
    }
  end
end
