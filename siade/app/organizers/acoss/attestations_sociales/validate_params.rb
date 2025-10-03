class ACOSS::AttestationsSociales::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    ACOSS::AttestationsSociales::ValidateUserIdPresence,
    ValidateRecipient
end
