class CNAV::FoyerRSA < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::FoyerRSA::MakeRequest

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'foyer_rsa'
  end
end
