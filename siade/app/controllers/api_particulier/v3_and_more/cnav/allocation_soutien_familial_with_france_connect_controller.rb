class APIParticulier::V3AndMore::CNAV::AllocationSoutienFamilialWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::AllocationSoutienFamilial }

  private

  def organizer_class
    CNAV::AllocationSoutienFamilial
  end

  def serializer_module
    ::APIParticulier::CNAV::AllocationSoutienFamilial
  end
end
