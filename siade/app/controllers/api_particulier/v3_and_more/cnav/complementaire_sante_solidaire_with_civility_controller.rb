class APIParticulier::V3AndMore::CNAV::ComplementaireSanteSolidaireWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  def organizer_class
    CNAV::ComplementaireSanteSolidaire
  end

  def serializer_module
    ::APIParticulier::CNAV::ComplementaireSanteSolidaire
  end
end
