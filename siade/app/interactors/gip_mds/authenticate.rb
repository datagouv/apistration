class GIPMDS::Authenticate < GetOAuth2Token
  private

  def client_url
    "#{Siade.credentials[:gip_mds_domain]}/token"
  end

  def client_id
    Siade.credentials[:gip_mds_client_id]
  end

  def client_secret
    Siade.credentials[:gip_mds_client_secret]
  end
end
