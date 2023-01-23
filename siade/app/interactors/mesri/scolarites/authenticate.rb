class MESRI::Scolarites::Authenticate < GetOAuth2Token
  def client_url
    Siade.credentials[:mesri_scolarite_authenticate_url]
  end

  def client_id
    Siade.credentials[:mesri_scolarite_client_id]
  end

  def client_secret
    Siade.credentials[:mesri_scolarite_client_secret]
  end
end
