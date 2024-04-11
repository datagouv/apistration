class APIParticulier::CNAV::AllocationAdulteHandicape::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    dateDebut
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:allocation_adulte_handicape) }
  end
end
