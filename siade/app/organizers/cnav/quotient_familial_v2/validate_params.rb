class CNAV::QuotientFamilialV2::ValidateParams < ValidateParamsOrganizer
  organize ValidateRecipient,
    CNAV::QuotientFamilialV2::ValidateYear,
    CNAV::QuotientFamilialV2::ValidateMonth,
    CNAV::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneNaissanceOrTranscogageParams,
    Civility::ValidateCodeCogINSEEPaysNaissance,
    CNAV::ValidateDateNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms,
    Civility::ValidateNomNaissance
end
