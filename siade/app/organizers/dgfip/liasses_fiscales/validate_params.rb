class DGFIP::LiassesFiscales::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    DGFIP::ValidateYear,
    DGFIP::ValidateUserId
end
