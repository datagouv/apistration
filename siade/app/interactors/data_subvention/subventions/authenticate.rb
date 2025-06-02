class DataSubvention::Subventions::Authenticate < AbstractGetToken
  private

  def extra_headers(request)
    request['accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
  end

  def access_token(response)
    JSON.parse(response.body)['user']['jwt']['token']
  end

  def expires_in(response)
    JSON.parse(response.body)['user']['jwt']['expirateDate']
  end

  def client_url
    "#{Siade.credentials[:data_subvention_url]}/auth/login"
  end

  def form_data
    {
      email: Siade.credentials[:data_subvention_email],
      password: Siade.credentials[:data_subvention_password]
    }
  end
end
