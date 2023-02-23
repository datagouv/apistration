class URSSAF::AttestationsSociales < RetrieverOrganizer
  organize ACOSS::AttestationsSociales::ValidateParams,
    ACOSS::AttestationsSociales::Authenticate,
    ACOSS::AttestationsSociales::MakeRequest,
    URSSAF::AttestationsSociales::ValidateResponse,
    URSSAF::AttestationsSociales::UploadDocument,
    URSSAF::AttestationsSociales::BuildResource

  def provider_name
    'ACOSS'
  end
end
