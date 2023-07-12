class DGFIP::AttestationFiscale::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    ServiceUser::ValidateUserId
end
