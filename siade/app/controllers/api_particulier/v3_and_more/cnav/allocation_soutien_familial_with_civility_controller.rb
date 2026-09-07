class APIParticulier::V3AndMore::CNAV::AllocationSoutienFamilialWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::AllocationSoutienFamilial }

  def organizer_class
    CNAV::AllocationSoutienFamilial
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationSoutienFamilial
  end
end
