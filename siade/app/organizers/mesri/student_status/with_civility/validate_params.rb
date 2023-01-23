class MESRI::StudentStatus::WithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthDate,
    ServiceUser::ValidateGender,
    ServiceUser::ValidateTokenId
end
