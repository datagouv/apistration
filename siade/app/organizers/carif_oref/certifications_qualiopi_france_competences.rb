class CarifOref::CertificationsQualiopiFranceCompetences < RetrieverOrganizer
  organize ValidateSiret,
    MockedInteractor

  def provider_name
    'CARIF-OREF'
  end
end
