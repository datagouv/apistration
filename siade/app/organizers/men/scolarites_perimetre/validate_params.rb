class MEN::ScolaritesPerimetre::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    MEN::Scolarites::ValidateAnneeScolaire,
    MEN::ScolaritesPerimetre::ValidateDegreEtablissement,
    MEN::ScolaritesPerimetre::ValidatePerimetre
end
