class CNAV::QuotientFamilialV2::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    CNAV::QuotientFamilialV2::ValidateYear,
    ServiceUser::ValidateGender,
    CNAV::ValidateCodeINSEELieuDeNaissanceOrTranscogageParams,
    CNAV::ValidateCodePaysLieuDeNaissance,
    CNAV::ValidateDateDeNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms
end
