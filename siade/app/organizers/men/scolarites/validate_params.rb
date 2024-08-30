class MEN::Scolarites::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateDeNaissance,
    Civility::ValidateSexeEtatCivil,
    MEN::Scolarites::ValidateCodeEtablissement,
    MEN::Scolarites::ValidateAnneeScolaire
end
