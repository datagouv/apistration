class ACOSS::AttestationsSociales::Authenticate < GetOAuth2Token
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
    Rails.application.config_for(:url_secrets).fetch(:acoss)
  end

  def client_id
    acoss_client_config.fetch(:client_id)
  end

  def client_secret
    acoss_client_config.fetch(:client_secret)
  end

  def acoss_client_config
    Rails.application.config_for(:api_secrets).fetch(:acoss)
  end
end
