class GIPMDS::ServiceCivique::Authenticate < GIPMDS::Authenticate
  private

  def client_id
    Siade.credentials[:gip_mds_dade_client_id]
  end

  def client_secret
    Siade.credentials[:gip_mds_dade_client_secret]
  end
end
