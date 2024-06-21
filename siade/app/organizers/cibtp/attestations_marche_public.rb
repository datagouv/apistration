class CIBTP::AttestationsMarchePublic < RetrieverOrganizer
  organize ValidateSiret,
    CIBTP::AttestationsMarchePublic::Authenticate,
    CIBTP::AttestationsMarchePublic::MakeRequest,
    CIBTP::AttestationsMarchePublic::ValidateResponse,
    CIBTP::AttestationsMarchePublic::UploadDocument,
    CIBTP::AttestationsMarchePublic::BuildResource

  def provider_name
    'CIBTP'
  end
end
