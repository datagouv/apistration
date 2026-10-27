class CNAV::ValidateTranscogageParams < ValidateParamsOrganizer
  organize INSEE::CommuneINSEECode::ValidateBirthdateYear,
    INSEE::CommuneINSEECode::ValidateCommuneName,
    INSEE::CommuneINSEECode::ValidateDepartementCode
end
