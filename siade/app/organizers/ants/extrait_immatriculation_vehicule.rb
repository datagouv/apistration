class ANTS::ExtraitImmatriculationVehicule < RetrieverOrganizer
  organize ANTS::ExtraitImmatriculationVehicule::ValidateParams,
    ANTS::ExtraitImmatriculationVehicule::MakeRequest,
    ANTS::ExtraitImmatriculationVehicule::ValidateResponse,
    ANTS::ExtraitImmatriculationVehicule::BuildResource

  def provider_name
    'ANTS'
  end
end
