class DSNJ::ServiceNational::ValidateParams < ValidateParamsOrganizer
  organize DSNJ::ServiceNational::ValidatePrenoms,
    DSNJ::ServiceNational::ValidateNomNaissance,
    Civility::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    DSNJ::ServiceNational::ValidateCodeCogINSEECommuneNaissance,
    Civility::ValidateCodeCogINSEEPaysNaissance
end
