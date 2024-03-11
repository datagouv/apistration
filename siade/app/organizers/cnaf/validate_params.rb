class CNAF::ValidateParams < ValidateParamsOrganizer
  organize CNAF::ValidateRecipient,
    ServiceUser::ValidateGender,
    CNAF::ValidateCodeINSEELieuDeNaissanceOrTranscogageParams,
    CNAF::ValidateCodePaysLieuDeNaissance,
    CNAF::ValidateDateDeNaissance,
    CNAF::ValidateRequestId,
    CNAF::ValidatePrenoms
end
