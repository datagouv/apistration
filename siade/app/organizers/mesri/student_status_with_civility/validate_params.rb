class MESRI::StudentStatusWithCivility::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateFamilyName,
    ServiceUser::ValidateFirstName,
    ServiceUser::ValidateBirthDate,
    MESRI::StudentStatusWithCivility::ValidateGender,
    ServiceUser::ValidateTokenId
end
