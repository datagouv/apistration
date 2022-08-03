class CNAF::QuotientFamilial::ValidateParams < ValidateParamsOrganizer
  organize ValidatePostalCode,
    CNAF::QuotientFamilial::ValidateBeneficiaryNumber
end
