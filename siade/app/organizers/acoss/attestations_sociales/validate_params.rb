class ACOSS::AttestationsSociales::ValidateParams < ValidateParamsOrganizer
  organize ValidateSiren,
    ACOSS::AttestationsSociales::ValidateUserIdPresence,
    ACOSS::AttestationsSociales::ValidateRecipientPresence
end
