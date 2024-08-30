class APIParticulier::V3AndMore::CNAV::AllocationAdulteHandicapeWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  def organizer_class
    CNAV::AllocationAdulteHandicape
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationAdulteHandicape
  end
end
