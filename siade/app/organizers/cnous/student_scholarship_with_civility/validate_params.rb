class CNOUS::StudentScholarshipWithCivility::ValidateParams < ValidateParamsOrganizer
  organize Civility::ValidateNomNaissance,
    Civility::ValidatePrenoms,
    Civility::ValidateDateNaissance,
    Civility::ExtractCodeCommuneFromTranscogage
end
