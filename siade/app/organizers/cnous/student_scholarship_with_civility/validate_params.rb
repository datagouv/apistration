class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstNames,
    ServiceUser::ValidateBirthdayDate,
    CNOUS::StudentScholarshipWithCivility::ValidateGender,
    ServiceUser::ValidateUserId
end
