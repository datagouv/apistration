class DGFIP::LiassesFiscales::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    DGFIP::ValidateYear,
    ServiceUser::ValidateUserId,
    DGFIP::ValidateRequestId
end
