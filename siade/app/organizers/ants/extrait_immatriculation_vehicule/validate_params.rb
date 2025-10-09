class ANTS::ExtraitImmatriculationVehicule::ValidateParams < ValidateParamsOrganizer
  organize ANTS::ExtraitImmatriculationVehicule::ValidateImmatriculationPresence,
    Civility::ValidatePrenoms,
    Civility::ValidateNomNaissance,
    Civility::ValidateDateNaissance
end
