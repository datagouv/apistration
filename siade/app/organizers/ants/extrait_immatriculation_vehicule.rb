class ANTS::ExtraitImmatriculationVehicule < RetrieverOrganizer
  organize ANTS::ExtraitImmatriculationVehicule::ValidateParams,
    ANTS::ExtraitImmatriculationVehicule::MakeRequest

  def provider_name
    'ANTS'
  end
end
