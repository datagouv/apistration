class APIParticulier::CNAV::AllocationRentreeScolaire::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    status
    date_debut_droit
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:cnav_allocation_rentree_scolaire) }
  end
end
