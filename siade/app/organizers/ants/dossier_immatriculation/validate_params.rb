class ANTS::DossierImmatriculation::ValidateParams < ValidateParamsOrganizer
  organize ANTS::DossierImmatriculation::ValidateImmatriculationPresence,
    Civility::ValidatePrenoms,
    Civility::ValidateNomNaissance,
    Civility::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    Civility::ValidateCodeCogINSEECommuneNaissance,
    Civility::ValidateCodeCogINSEEPaysNaissance
end
