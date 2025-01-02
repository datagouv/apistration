class MESRI::StudentStatus::WithCivility::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    Civility::ValidateCodeCogINSEECommuneNaissance,
    ServiceUser::ValidateTokenId
end
