class CNAV::PrimeActivite < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ValidateResponse,
    CNAV::PrimeActivite::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'prime_activite'
  end
end
