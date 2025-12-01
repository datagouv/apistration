class APIParticulier::V3AndMore::CNAV::AllocationEnfantHandicapeWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  private

  def organizer_class
    CNAV::AllocationEnfantHandicape
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationEnfantHandicape
  end
end
