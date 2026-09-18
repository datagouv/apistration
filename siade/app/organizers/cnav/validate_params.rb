class CNAV::ValidateParams < ValidateParamsOrganizer
  organize ValidateRecipient,
    CNAV::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneNaissanceOrTranscogageParams,
    Civility::ValidateCodeCogINSEEPaysNaissance,
    CNAV::ValidateDateNaissance,
    CNAV::ValidatePrenoms,
    Civility::ValidateNomNaissance
end
