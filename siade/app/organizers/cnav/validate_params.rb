class CNAV::ValidateParams < ValidateParamsOrganizer
  organize CNAV::ValidateRecipient,
    Civility::ValidateSexeEtatCivil,
    CNAV::ValidateCodeCogINSEECommuneDeNaissanceOrTranscogageParams,
    CNAV::ValidateCodePaysLieuDeNaissance,
    CNAV::ValidateDateDeNaissance,
    CNAV::ValidateRequestId,
    Civility::ValidatePrenoms,
    Civility::ValidateNomNaissance
end
