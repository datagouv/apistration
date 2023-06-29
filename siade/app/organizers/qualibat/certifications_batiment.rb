class QUALIBAT::CertificationsBatiment < RetrieverOrganizer
  organize ValidateSiret,
    QUALIBAT::CertificationsBatiment::Authenticate,
    QUALIBAT::CertificationsBatiment::MakeRequest,
    QUALIBAT::CertificationsBatiment::ValidateResponse,
    QUALIBAT::CertificationsBatiment::UploadDocument,
    QUALIBAT::CertificationsBatiment::BuildResource

  def provider_name
    'Qualibat'
  end
end
