class CNAF::ValidateParams < ValidateParamsOrganizer
  organize ServiceUser::ValidateGender,
    CNAF::ValidateCodePaysLieuDeNaissance,
    CNAF::ValidateCodeINSEELieuDeNaissance,
    CNAF::ValidateDateDeNaissance,
    CNAF::ValidateRequestId
  # CNAF::ValidateUserSiret,
end
