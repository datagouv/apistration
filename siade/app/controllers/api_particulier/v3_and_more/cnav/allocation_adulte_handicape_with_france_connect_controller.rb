class APIParticulier::V3AndMore::CNAV::AllocationAdulteHandicapeWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  private

  def organizer_class
    CNAV::AllocationAdulteHandicape
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationAdulteHandicape
  end
end
