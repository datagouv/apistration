class CNAV::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    ServiceUser::ValidateGender,
    CNAV::ValidateCodeINSEELieuDeNaissanceOrTranscogageParams,
    CNAV::ValidateCodePaysLieuDeNaissance,
    CNAV::ValidateDateDeNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms,
    CNAV::ValidateNomNaissance
end
