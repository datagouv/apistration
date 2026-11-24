class CNAV::FoyerRSA < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::FoyerRSA::ValidateResponse,
    CNAV::FoyerRSA::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def data_source
    context.regime
  end

  def dss_prestation_name
    'foyer_rsa'
  end
end
