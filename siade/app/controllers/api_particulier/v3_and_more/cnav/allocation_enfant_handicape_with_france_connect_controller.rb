class APIParticulier::V3AndMore::CNAV::AllocationEnfantHandicapeWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::AllocationEnfantHandicape }

  private

  def organizer_class
    CNAV::AllocationEnfantHandicape
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationEnfantHandicape
  end
end
