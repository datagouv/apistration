class APIParticulier::CNAV::AllocationAdulteHandicape::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    status
    dateDebut
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:allocation_adulte_handicape) }
  end
end
