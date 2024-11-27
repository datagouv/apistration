class INSEE::Authenticate < GetOAuth2Token
  protected

  def extra_headers(request)
    request['Authorization'] = "Basic #{client_credentials_header}"
  end

  def client_url
    "#{Siade.credentials[:insee_v3_domain]}/token"
  end

  private

  def client_credentials_header
    Siade.credentials[:insee_credentials]
  end
end
