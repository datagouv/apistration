class APIParticulier::CNAF::AllocationSoutienFamilial::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:allocations_soutien_familial) }
  end
end
