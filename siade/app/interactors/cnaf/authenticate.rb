class CNAF::Authenticate < GetOAuth2Token
  def extra_headers(request)
    request['Authorization'] = "Basic #{client_credentials_header}"
  end

  def client_url
    Siade.credentials[:cnaf_authenticate_url]
  end

  private

  def prestation
    context.dss_prestation_name
  end

  def scope
    Siade.credentials[:"cnaf_#{prestation}_scope"]
  end

  def client_credentials_header
    Base64.urlsafe_encode64("#{client_id}:#{client_secret}")
  end

  def client_id
    Siade.credentials[:"cnaf_#{prestation}_client_id"]
  end

  def client_secret
    Siade.credentials[:"cnaf_#{prestation}_client_secret"]
  end

  def form_data
    {
      grant_type: 'client_credentials',
      scope:
    }.compact
  end
end
