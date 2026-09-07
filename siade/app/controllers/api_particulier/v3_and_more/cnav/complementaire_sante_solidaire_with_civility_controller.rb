class APIParticulier::V3AndMore::CNAV::ComplementaireSanteSolidaireWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::ComplementaireSanteSolidaire }

  def organizer_class
    CNAV::ComplementaireSanteSolidaire
  end

  def serializer_module
    ::APIParticulier::CNAV::ComplementaireSanteSolidaire
  end
end
