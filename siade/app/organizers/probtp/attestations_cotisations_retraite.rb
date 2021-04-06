class PROBTP::AttestationsCotisationsRetraite < ApplicationOrganizer
  organize PROBTP::AttestationsCotisationsRetraite::MakeRequest,
           PROBTP::AttestationsCotisationsRetraite::ValidateResponse,
           PROBTP::UploadAttestationsCotisationRetraite,
           PROBTP::AttestationsCotisationsRetraite::BuildResource
end
