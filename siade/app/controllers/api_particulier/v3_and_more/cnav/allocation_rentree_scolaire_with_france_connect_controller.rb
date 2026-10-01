class APIParticulier::V3AndMore::CNAV::AllocationRentreeScolaireWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::AllocationRentreeScolaire }

  private

  def organizer_class
    CNAV::AllocationRentreeScolaire
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationRentreeScolaire
  end
end
