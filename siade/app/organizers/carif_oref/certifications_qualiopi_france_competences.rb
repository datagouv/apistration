class CarifOref::CertificationsQualiopiFranceCompetences < RetrieverOrganizer
  organize ValidateSiret,
    CarifOref::CertificationsQualiopiFranceCompetences::MakeRequest,
    CarifOref::CertificationsQualiopiFranceCompetences::ValidateResponse,
    CarifOref::CertificationsQualiopiFranceCompetences::BuildResource

  def provider_name
    'CARIF-OREF'
  end
end
