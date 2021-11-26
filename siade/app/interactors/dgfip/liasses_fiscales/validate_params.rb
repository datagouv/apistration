class DGFIP::LiassesFiscales::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    ValidateYear,
    DGFIP::ValidateUserId
end
