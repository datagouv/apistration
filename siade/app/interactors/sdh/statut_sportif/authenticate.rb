class SDH::StatutSportif::Authenticate < GetOAuth2Token
  def client_url
    Siade.credentials[:sdh_authenticate_url]
  end

  def client_id
    Siade.credentials[:sdh_client_id]
  end

  def client_secret
    Siade.credentials[:sdh_client_secret]
  end
end
