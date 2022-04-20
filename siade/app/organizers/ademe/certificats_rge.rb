class ADEME::CertificatsRGE < RetrieverOrganizer
  organize ValidateSiret,
    ADEME::CertificatsRGE::MakeRequest,
    ADEME::CertificatsRGE::ValidateResponse,
    ADEME::CertificatsRGE::BuildResource

  def provider_name
    'ADEME'
  end
end
