class CNAF::QuotientFamilialV2::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateGender,
    CNAF::QuotientFamilialV2::ValidateCodePaysLieuDeNaissance,
    CNAF::QuotientFamilialV2::ValidateCodeINSEELieuDeNaissance,
    CNAF::QuotientFamilialV2::ValidateDateDeNaissance,
    CNAF::QuotientFamilialV2::ValidateRequestId
  # CNAF::QuotientFamilialV2::ValidateUserSiret,
end
