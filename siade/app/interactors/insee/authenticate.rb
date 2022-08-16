class INSEE::Authenticate < GetOAuth2Token
  protected

  def headers
    {
      Authorization: "Basic #{client_credentials_header}"
    }
  end

  def client_url
    "#{Siade.credentials[:insee_v3_domain]}/token"
  end

  def request_options
    {
      verify_mode: OpenSSL::SSL::VERIFY_PEER
    }
  end

  private

  def client_credentials_header
    Siade.credentials[:insee_credentials]
  end
end
