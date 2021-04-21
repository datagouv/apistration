class PROBTP::AttestationsCotisationsRetraite < ApplicationOrganizer
  organize ValidateSiren,
           PROBTP::AttestationsCotisationsRetraite::MakeRequest,
           PROBTP::AttestationsCotisationsRetraite::ValidateResponse,
           PROBTP::UploadAttestationsCotisationRetraite,
           PROBTP::AttestationsCotisationsRetraite::BuildResource
end
