class DGFIP::LiassesFiscales::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    DGFIP::ValidateYear,
    ServiceUser::ValidateUserId
end
