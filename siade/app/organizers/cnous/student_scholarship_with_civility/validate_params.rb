class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateDeNaissance
end
