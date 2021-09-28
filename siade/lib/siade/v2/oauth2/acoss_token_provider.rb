class SIADE::V2::OAuth2::ACOSSTokenProvider
  include SIADE::V2::OAuth2::AbstractTokenProvider

  SCOPE_API_ENTREPRISE = 'attn.api_entreprise'

  private

  def client_get_token_params
    {
      grant_type: :client_credentials,
      scope: SCOPE_API_ENTREPRISE
    }
  end

  def client_options
    {
      site: domain,
      token_url: access_token_path
    }
  end

  def access_token_options
    { refresh_token: nil }
  end

  def access_token_path
    '/api/oauth/v1/token'
  end

  def domain
    Siade.credentials[:acoss_domain]
  end

  def client_id
    Siade.credentials[:acoss_client_id]
  end

  def client_secret
    Siade.credentials[:acoss_client_secret]
  end
end
