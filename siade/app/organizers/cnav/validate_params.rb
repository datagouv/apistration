class CNAV::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ReplaceTypographicApostrophes,
    ValidateRecipient,
    CNAV::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneNaissanceOrTranscogageParams,
    Civility::ValidateCodeCogINSEEPaysNaissance,
    CNAV::ValidateDateNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms,
    Civility::ValidateNomNaissance,
    Civility::ValidateNomUsage
end
