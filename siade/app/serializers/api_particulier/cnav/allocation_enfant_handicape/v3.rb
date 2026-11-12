class APIParticulier::CNAV::AllocationEnfantHandicape::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    status
    date_debut_droit
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:cnav_allocation_enfant_handicape) }
  end
end
