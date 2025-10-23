class ANTS::ExtraitImmatriculationVehicule::ValidateIdentityMatching < ApplicationOrganizer
  around do |interactor|
    interactor.call unless use_mocked_data?
  end

  organize ANTS::ExtraitImmatriculationVehicule::ExtractIdentities,
    ANTS::ExtraitImmatriculationVehicule::ValidateOneIdentityIsMatching
end
