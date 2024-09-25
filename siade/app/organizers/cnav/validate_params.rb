class CNAV::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    Civility::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneNaissanceOrTranscogageParams,
    CNAV::ValidateCodeCogINSEEPaysNaissance,
    CNAV::ValidateDateNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms,
    Civility::ValidateNomNaissance
end
