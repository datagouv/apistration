class CNAV::QuotientFamilialV2::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    CNAV::QuotientFamilialV2::ValidateYear,
    CNAV::QuotientFamilialV2::ValidateMonth,
    Civility::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneNaissanceOrTranscogageParams,
    Civility::ValidateCodeCogINSEEPaysNaissance,
    CNAV::ValidateDateNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms,
    Civility::ValidateNomNaissance
end
