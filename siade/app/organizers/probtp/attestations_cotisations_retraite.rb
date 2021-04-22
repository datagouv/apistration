class PROBTP::AttestationsCotisationsRetraite < ApplicationOrganizer
  organize ValidateSiret,
           PROBTP::AttestationsCotisationsRetraite::MakeRequest,
           PROBTP::AttestationsCotisationsRetraite::ValidateResponse,
           PROBTP::UploadAttestationsCotisationRetraite,
           PROBTP::AttestationsCotisationsRetraite::BuildResource
end
