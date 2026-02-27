class MEN::Scolarites::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    MEN::Scolarites::ValidateSearchParams,
    MEN::Scolarites::ValidateAnneeScolaire
end
