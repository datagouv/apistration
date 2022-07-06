class DGFIP::DerniereSituationIR::Authenticate < GetOAuth2Token
  SCOPE_API_PARTICULIER = 'RessourceIRDerniere2'.freeze

  protected

  def client_url
    "#{Siade.credentials[:dgfip_apim_domain]}/token"
  end

  def scope
    SCOPE_API_PARTICULIER
  end

  def client_id
    Siade.credentials[:dgfip_derniere_situation_ir_client_id]
  end

  def client_secret
    Siade.credentials[:dgfip_derniere_situation_ir_client_secret]
  end
end
