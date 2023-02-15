class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstNames,
    ServiceUser::ValidateBirthPlace,
    CNOUS::StudentScholarshipWithCivility::ValidateBirthDate,
    CNOUS::StudentScholarshipWithCivility::ValidateGender
end
