class CNAF::QuotientFamilialV2::Authenticate < GetOAuth2Token
  protected

  def extra_headers(request)
    request['Authorization'] = "Basic #{client_credentials_header}"
  end

  def client_url
    Siade.credentials[:cnaf_authenticate_url]
  end

  private

  def scope
    Siade.credentials[:cnaf_quotient_familial_v2_scope]
  end

  def client_credentials_header
    Base64.urlsafe_encode64("#{client_id}:#{client_secret}")
  end

  def client_id
    Siade.credentials[:cnaf_quotient_familial_v2_client_id]
  end

  def client_secret
    Siade.credentials[:cnaf_quotient_familial_v2_client_secret]
  end

  def form_data
    {
      grant_type: 'client_credentials',
      scope:
    }.compact
  end
end
