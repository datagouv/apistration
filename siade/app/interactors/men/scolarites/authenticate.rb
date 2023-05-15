class MEN::Scolarites::Authenticate < GetOAuth2Token
  def client_url
    Siade.credentials[:men_scolarites_authenticate_url]
  end

  def client_id
    Siade.credentials[:men_scolarites_client_id]
  end

  def client_secret
    Siade.credentials[:men_scolarites_client_secret]
  end
end
