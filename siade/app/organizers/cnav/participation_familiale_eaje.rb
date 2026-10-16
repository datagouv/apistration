class CNAV::ParticipationFamilialeEAJE < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    CNAV::Authenticate,
    CNAV::MakeRequest,
    CNAV::ParticipationFamilialeEAJE::ValidateResponse,
    CNAV::ParticipationFamilialeEAJE::BuildResource

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'participation_familiale_eaje'
  end
end
