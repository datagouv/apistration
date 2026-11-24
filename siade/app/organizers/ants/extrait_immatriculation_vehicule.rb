class ANTS::ExtraitImmatriculationVehicule < RetrieverOrganizer
  organize ANTS::ExtraitImmatriculationVehicule::ValidateParams,
    ANTS::Authenticate,
    ANTS::ExtraitImmatriculationVehicule::MakeRequest,
    ANTS::ExtraitImmatriculationVehicule::ValidateHTTPResponse,
    ANTS::ExtraitImmatriculationVehicule::SelectRequesterHolder,
    ANTS::ExtraitImmatriculationVehicule::BuildResource

  def provider_name
    'ANTS'
  end
end
