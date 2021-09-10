class ACOSS::AttestationsSociales < RetrieverOrganizer
  organize ACOSS::AttestationsSociales::ValidateParams,
    ACOSS::AttestationsSociales::Authenticate,
    ACOSS::AttestationsSociales::MakeRequest,
    ACOSS::AttestationsSociales::ValidateResponse,
    ACOSS::AttestationsSociales::UploadDocument,
    ACOSS::AttestationsSociales::BuildResource

  def provider_name
    'ACOSS'
  end
end
