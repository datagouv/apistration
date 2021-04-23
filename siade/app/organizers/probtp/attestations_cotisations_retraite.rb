class PROBTP::AttestationsCotisationsRetraite < RetrieverOrganizer
  organize ValidateSiret,
           PROBTP::AttestationsCotisationsRetraite::MakeRequest,
           PROBTP::AttestationsCotisationsRetraite::ValidateResponse,
           PROBTP::UploadAttestationsCotisationRetraite,
           PROBTP::AttestationsCotisationsRetraite::BuildResource

  def provider_name
    'ProBTP'
  end
end
