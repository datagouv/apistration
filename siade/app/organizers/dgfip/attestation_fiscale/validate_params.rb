class DGFIP::AttestationFiscale::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    ServiceUser::ValidateUserId,
    DGFIP::ValidateRequestId
end
