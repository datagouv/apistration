class PoleEmploi::Authenticate < GetOAuth2Token
  private

  def client_get_token_params
    {
      grant_type: :client_credentials,
      scope: scopes
    }
  end

  def client_options
    {
      token_url: authenticate_url
    }
  end

  def access_token_options
    {}
  end

  def scopes
    [
      'api_statutaugmentev1',
      'individuStatutAugmente',
      "application_#{client_id}"
    ].join(' ')
  end

  def authenticate_url
    Siade.credentials[:pole_emploi_authenticate_url]
  end

  def client_id
    Siade.credentials[:pole_emploi_client_id]
  end

  def client_secret
    Siade.credentials[:pole_emploi_client_secret]
  end
end
