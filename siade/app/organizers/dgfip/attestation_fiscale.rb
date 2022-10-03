class DGFIP::AttestationFiscale < RetrieverOrganizer
  organize DGFIP::AttestationFiscale::ValidateParams,
    DGFIP::Authenticate,
    DGFIP::AttestationFiscale::MakeRequest,
    DGFIP::AttestationFiscale::ValidateResponse,
    DGFIP::AttestationFiscale::UploadDocument,
    DGFIP::AttestationFiscale::BuildResource

  def provider_name
    'DGFIP - Adélie'
  end
end
