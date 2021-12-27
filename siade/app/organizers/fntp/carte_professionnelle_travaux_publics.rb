class FNTP::CarteProfessionnelleTravauxPublics < RetrieverOrganizer
  organize ValidateSiren,
    FNTP::CarteProfessionnelleTravauxPublics::MakeRequest,
    FNTP::CarteProfessionnelleTravauxPublics::ValidateResponse,
    FNTP::CarteProfessionnelleTravauxPublics::UploadDocument,
    FNTP::CarteProfessionnelleTravauxPublics::BuildResource

  def provider_name
    'FNTP'
  end
end
