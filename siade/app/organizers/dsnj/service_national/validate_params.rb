class DSNJ::ServiceNational::ValidateParams < ValidateParamsOrganizer
  organize DSNJ::ServiceNational::ValidatePrenoms,
    DSNJ::ServiceNational::ValidateNomNaissance,
    DSNJ::ServiceNational::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    Civility::ValidateCodeCogINSEECommuneNaissance,
    Civility::ValidateCodeCogINSEEPaysNaissance
end
