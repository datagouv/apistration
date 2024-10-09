class APIParticulier::CNAV::AllocationAdulteHandicape::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    est_beneficiaire
    date_debut_droit
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:allocation_adulte_handicape) }
  end
end
