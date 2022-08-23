class ValidateParams::StudentINE < ValidateParamsOrganizer
  organize Individual::ValidateINE,
    Individual::ValidateUserId
end
