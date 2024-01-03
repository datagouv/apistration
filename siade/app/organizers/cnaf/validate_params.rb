class CNAF::ValidateParams < ValidateParamsOrganizer
  organize CNAF::ValidateRecipient,
    ServiceUser::ValidateGender,
    CNAF::ValidateCodePaysLieuDeNaissance,
    CNAF::ValidateCodeINSEELieuDeNaissance,
    CNAF::ValidateDateDeNaissance,
    CNAF::ValidateRequestId,
    CNAF::ValidatePrenoms
end
