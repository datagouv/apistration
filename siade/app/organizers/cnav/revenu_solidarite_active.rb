class CNAV::RevenuSolidariteActive < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ValidateResponse,
    CNAV::RevenuSolidariteActive::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'revenu_solidarite_active'
  end
end
