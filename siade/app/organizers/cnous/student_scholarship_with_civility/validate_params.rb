class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstNames,
    ServiceUser::ValidateBirthPlace,
    ServiceUser::ValidateGender,
    ServiceUser::ValidateBirthDate
end
