class APIParticulier::V3AndMore::CNAV::AllocationRentreeScolaireWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  private

  def organizer_class
    CNAV::AllocationRentreeScolaire
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationRentreeScolaire
  end
end
