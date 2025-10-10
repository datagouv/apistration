class ANTS::ExtraitImmatriculationVehicule::ValidateIdentityMatching < ApplicationOrganizer
  around do |interactor|
    interactor.call unless clogged_env?
  end

  organize ANTS::ExtraitImmatriculationVehicule::ExtractIdentities,
    ANTS::ExtraitImmatriculationVehicule::ValidateOneIdentityIsMatching
end
