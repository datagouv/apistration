class ValidateParams::StudentCivility < ValidateParamsOrganizer
  organize Individual::ValidateFamilyName,
    Individual::ValidateFirstName,
    Individual::ValidateBirthdayDate,
    Individual::ValidateGender,
    Individual::ValidateUserId
end
