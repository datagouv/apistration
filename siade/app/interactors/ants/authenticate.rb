class ANTS::Authenticate < GetOAuth2Token
  include UseWildcardSSLCertificate

  def http_options
    http_wildcard_ssl_options
  end

  def client_url
    Siade.credentials[:ants_siv2_token_url]
  end

  def client_id
    Siade.credentials[:ants_siv2_client_id]
  end

  private

  def form_data
    {
      client_id:,
      grant_type: 'client_credentials'
    }
  end
end
