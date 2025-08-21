class ANTS::ExtraitImmatriculationVehicule::ValidateIdentityMatching < ApplicationOrganizer
  organize ANTS::ExtraitImmatriculationVehicule::ExtractIdentities,
    ANTS::ExtraitImmatriculationVehicule::ValidateOneIdentityIsMatching
end
