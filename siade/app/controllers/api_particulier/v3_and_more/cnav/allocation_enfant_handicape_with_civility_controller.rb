class APIParticulier::V3AndMore::CNAV::AllocationEnfantHandicapeWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::AllocationEnfantHandicape }

  private

  def organizer_class
    CNAV::AllocationEnfantHandicape
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationEnfantHandicape
  end
end
