class CIBTP::AttestationCotisationsCongesPayesChomageIntemperies < RetrieverOrganizer
  organize ValidateSiret,
    CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::Authenticate,
    CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::MakeRequest,
    CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::ValidateResponse,
    CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::UploadDocument,
    CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::BuildResource

  def provider_name
    'CIBTP'
  end
end
