class MESRI::Scolarites::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthDate,
    ServiceUser::ValidateGender,
    MESRI::Scolarites::ValidateCodeEtablissement,
    MESRI::Scolarites::ValidateAnneeScolaire
end
