class MESRI::Scolarite::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthdayDate,
    ServiceUser::ValidateGender,
    MESRI::Scolarite::ValidateCodeEtablissement,
    MESRI::Scolarite::ValidateAnneeScolaire
end
