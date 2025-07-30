class ANTS::ExtraitImmatriculationVehicule::ValidateParams < ValidateParamsOrganizer
  organize ANTS::ExtraitImmatriculationVehicule::ValidateImmatriculationPresence,
    Civility::ValidatePrenoms,
    Civility::ValidateNomNaissance,
    Civility::ValidateDateNaissance,
    Civility::ValidateSexeEtatCivil,
    Civility::ValidateCodeCogINSEECommuneNaissance,
    Civility::ValidateCodeCogINSEEPaysNaissance
end
