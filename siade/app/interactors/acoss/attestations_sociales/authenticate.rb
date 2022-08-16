class ACOSS::AttestationsSociales::Authenticate < GetOAuth2Token
  SCOPE_API_ENTREPRISE = 'attn.api_entreprise'.freeze

  def client_url
    "#{Siade.credentials[:acoss_domain]}/api/oauth/v1/token"
  end

  def client_id
    Siade.credentials[:acoss_client_id]
  end

  def client_secret
    Siade.credentials[:acoss_client_secret]
  end

  def scope
    SCOPE_API_ENTREPRISE
  end
end
