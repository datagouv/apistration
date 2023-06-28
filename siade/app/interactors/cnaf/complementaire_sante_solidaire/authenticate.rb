class CNAF::ComplementaireSanteSolidaire::Authenticate < GetOAuth2Token
  private

  def client_url
    Siade.credentials[:cnaf_authenticate_url]
  end

  def scope
    Siade.credentials[:cnaf_complementaire_sante_solidaire_scope]
  end

  def client_id
    Siade.credentials[:cnaf_complementaire_sante_solidaire_client_id]
  end

  def client_secret
    Siade.credentials[:cnaf_complementaire_sante_solidaire_client_secret]
  end

  def form_data
    {
      grant_type: 'client_credentials',
      scope:
    }.compact
  end
end
