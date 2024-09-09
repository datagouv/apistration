class CNAV::QuotientFamilialV2::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    CNAV::QuotientFamilialV2::ValidateYear,
    CNAV::QuotientFamilialV2::ValidateMonth,
    Civility::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneDeNaissanceOrTranscogageParams,
    CNAV::ValidateCodePaysLieuDeNaissance,
    CNAV::ValidateDateDeNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms
end
