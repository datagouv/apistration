class DGFIP::AttestationFiscale::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    DGFIP::ValidateUserId
end
