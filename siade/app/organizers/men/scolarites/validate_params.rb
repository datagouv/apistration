class MEN::Scolarites::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthDate,
    ServiceUser::ValidateGender,
    MEN::Scolarites::ValidateCodeEtablissement,
    MEN::Scolarites::ValidateAnneeScolaire
end
