class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstNames,
    ServiceUser::ValidateBirthdayPlace,
    CNOUS::StudentScholarshipWithCivility::ValidateBirthdayDate,
    CNOUS::StudentScholarshipWithCivility::ValidateGender,
    ServiceUser::ValidateUserId
end
