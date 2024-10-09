class APIParticulier::CNAV::AllocationSoutienFamilial::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    est_beneficiaire
    date_debut_droit
    date_fin_droit
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:allocation_soutien_familial) }
  end
end
