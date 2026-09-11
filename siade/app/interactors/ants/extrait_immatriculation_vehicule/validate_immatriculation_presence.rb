class ANTS::ExtraitImmatriculationVehicule::ValidateImmatriculationPresence < ValidateAttributePresence
  raises UnprocessableEntityError, field: :immatriculation

  def attribute
    :immatriculation
  end
end
