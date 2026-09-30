class CNAV::ValidateTranscogageParams < ValidateParamsOrganizer
  organize INSEE::CommuneINSEECode::ValidateBirthdateYear,
    INSEE::CommuneINSEECode::ValidateDepartementCode
end
