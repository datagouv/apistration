class MESRI::ValidateParamsStudentCivility < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthdayDate,
    MESRI::StudentStatusWithCivility::ValidateGender,
    ServiceUser::ValidateUserId
end
