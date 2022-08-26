class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstNames,
    ServiceUser::ValidateBirthdayDate,
    ServiceUser::ValidateBirthdayPlace,
    CNOUS::StudentScholarshipWithCivility::ValidateGender,
    ServiceUser::ValidateUserId
end
