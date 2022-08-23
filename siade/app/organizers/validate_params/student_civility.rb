class ValidateParams::StudentCivility < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthdayDate,
    ServiceUser::ValidateGender,
    ServiceUser::ValidateUserId
end
