class MESRI::StudentStatus::WithCivility::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    ServiceUser::ValidateTokenId,
    Civility::ExtractCodeCommuneFromTranscogage,
    Civility::ValidateCodeCogINSEECommuneNaissance
end
