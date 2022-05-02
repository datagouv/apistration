class ADEME::CertificatsRGE < RetrieverOrganizer
  organize ValidateSiret,
    ADEME::ValidateLimit,
    ADEME::CertificatsRGE::MakeRequest,
    ADEME::CertificatsRGE::ValidateResponse,
    ADEME::CertificatsRGE::BuildResourceCollection

  def provider_name
    'ADEME'
  end
end
