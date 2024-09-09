class CNAV::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    Civility::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneDeNaissanceOrTranscogageParams,
    CNAV::ValidateCodePaysLieuDeNaissance,
    CNAV::ValidateDateDeNaissance,
    CNAV::ValidateRequestId,
    CNAV::ValidatePrenoms,
    Civility::ValidateNomNaissance
end
