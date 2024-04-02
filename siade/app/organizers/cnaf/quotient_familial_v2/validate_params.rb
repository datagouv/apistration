class CNAF::QuotientFamilialV2::ValidateParams < ValidateParamsOrganizer
  organize CNAF::ValidateRecipient,
    CNAF::QuotientFamilialV2::ValidateYear,
    ServiceUser::ValidateGender,
    CNAF::ValidateCodeINSEELieuDeNaissanceOrTranscogageParams,
    CNAF::ValidateCodePaysLieuDeNaissance,
    CNAF::ValidateDateDeNaissance,
    CNAF::ValidateRequestId,
    CNAF::ValidatePrenoms
end
