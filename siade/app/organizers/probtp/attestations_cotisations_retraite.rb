class PROBTP::AttestationsCotisationsRetraite < ApplicationOrganizer
  organize PROBTP::AttestationsCotisationsRetraite::MakeRequest,
           PROBTP::AttestationsCotisationsRetraite::ValidateResponse,
           PROBTP::AttestationsCotisationsRetraite::PrepareDocumentStorage,
           Documents::StoreFromBase64,
           PROBTP::AttestationsCotisationsRetraite::BuildResource
end
