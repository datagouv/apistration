class APIParticulier::V3AndMore::CNAV::AllocationRentreeScolaireWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  private

  def organizer_class
    CNAV::AllocationRentreeScolaire
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationRentreeScolaire
  end
end
