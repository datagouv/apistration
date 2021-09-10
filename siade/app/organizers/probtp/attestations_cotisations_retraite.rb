class PROBTP::AttestationsCotisationsRetraite < RetrieverOrganizer
  organize ValidateSiret,
    PROBTP::AttestationsCotisationsRetraite::MakeRequest,
    PROBTP::AttestationsCotisationsRetraite::ValidateResponse,
    PROBTP::AttestationsCotisationsRetraite::UploadDocument,
    PROBTP::AttestationsCotisationsRetraite::BuildResource

  def provider_name
    'ProBTP'
  end
end
