class DGFIP::ADELIE::Authenticate < GetOAuth2Token
  def client_url
    "#{Siade.credentials[:dgfip_apim_base_url]}/token"
  end

  def client_id
    Siade.credentials[:dgfip_apim_client_id]
  end

  def client_secret
    Siade.credentials[:dgfip_apim_client_secret]
  end

  def scope
    nil
  end
end
