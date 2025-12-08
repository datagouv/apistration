class CNOUS::Authenticate < GetOAuth2Token
  private

  def extra_headers(request)
    request['Authorization'] = "Basic #{client_credentials_header}"
    request['Accept'] = 'application/json'
  end

  def client_credentials_header
    Base64.strict_encode64("#{client_id}:#{client_secret}")
  end

  def client_id
    Siade.credentials[:cnous_client_id]
  end

  def client_secret
    Siade.credentials[:cnous_client_secret]
  end

  def client_url
    Siade.credentials[:cnous_authenticate_url]
  end

  def form_data
    {}
  end
end
