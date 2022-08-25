class MESRI::StudentStatusWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthdayDate,
    MESRI::StudentStatusWithCivility::ValidateGender,
    ServiceUser::ValidateUserId
end
