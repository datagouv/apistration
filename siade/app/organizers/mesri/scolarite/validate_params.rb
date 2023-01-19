class MESRI::Scolarite::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthdayDate,
    MESRI::Scolarite::ValidateGender,
    MESRI::Scolarite::ValidateCodeEtablissement,
    MESRI::Scolarite::ValidateAnneeScolaire
end
