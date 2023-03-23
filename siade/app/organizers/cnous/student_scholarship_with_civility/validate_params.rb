class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstNames,
    ServiceUser::ValidateBirthDate
end
