class CNETP::AttestationCotisationsCongesPayesChomageIntemperies < RetrieverOrganizer
  organize ValidateSiren,
    CNETP::AttestationCotisationsCongesPayesChomageIntemperies::MakeRequest,
    CNETP::AttestationCotisationsCongesPayesChomageIntemperies::ValidateResponse,
    CNETP::AttestationCotisationsCongesPayesChomageIntemperies::UploadDocument,
    CNETP::AttestationCotisationsCongesPayesChomageIntemperies::BuildResource

  def provider_name
    'CNETP'
  end
end
