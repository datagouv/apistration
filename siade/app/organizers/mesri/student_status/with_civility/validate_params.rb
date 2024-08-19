class MESRI::StudentStatus::WithCivility::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateDeNaissance,
    Civility::ValidateSexeEtatCivil,
    ServiceUser::ValidateTokenId
end
