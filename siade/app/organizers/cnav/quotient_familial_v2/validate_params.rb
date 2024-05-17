class CNAV::QuotientFamilialV2::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    CNAV::QuotientFamilialV2::ValidateYear,
    CNAV::QuotientFamilialV2::ValidateMonth,
    ServiceUser::ValidateGender,
    CNAV::ValidateCodeINSEELieuDeNaissanceOrTranscogageParams,
    CNAV::ValidateCodePaysLieuDeNaissance,
    CNAV::ValidateDateDeNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms
end
