class CNOUS::ValidateParamsStudentCivility < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstNames,
    ServiceUser::ValidateBirthdayDate,
    CNOUS::StudentScholarshipWithCivility::ValidateGender,
    ServiceUser::ValidateUserId
end
