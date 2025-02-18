class CNAV::ParticipationFamilialPSU < CNAV::RetrieverOrganizer
  organize CNAV::ValidateParams,
    MockedInteractor

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'participation_familial_psu'
  end
end
