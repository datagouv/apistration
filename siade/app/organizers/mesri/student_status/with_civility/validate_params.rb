class MESRI::StudentStatus::WithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthDate,
    MESRI::StudentStatus::WithCivility::ValidateGender,
    ServiceUser::ValidateTokenId
end
