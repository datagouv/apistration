class APIParticulier::V3AndMore::CNAV::AllocationRentreeScolaireWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::AllocationRentreeScolaire }

  private

  def organizer_class
    CNAV::AllocationRentreeScolaire
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationRentreeScolaire
  end
end
