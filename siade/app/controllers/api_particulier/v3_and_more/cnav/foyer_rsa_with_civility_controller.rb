class APIParticulier::V3AndMore::CNAV::FoyerRSAWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::FoyerRSA }

  private

  def organizer_class
    CNAV::FoyerRSA
  end

  def serializer_module
    ::APIParticulier::CNAV::FoyerRSASerializer
  end
end
