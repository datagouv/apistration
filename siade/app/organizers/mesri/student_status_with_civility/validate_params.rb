class MESRI::StudentStatusWithCivility::ValidateParams < ValidateParamsOrganizer
  organize MESRI::StudentStatusWithCivility::ValidateFamilyName,
    MESRI::StudentStatusWithCivility::ValidateFirstName,
    MESRI::StudentStatusWithCivility::ValidateBirthdayDate,
    MESRI::StudentStatusWithCivility::ValidateGender,
    MESRI::ValidateUserId
end
