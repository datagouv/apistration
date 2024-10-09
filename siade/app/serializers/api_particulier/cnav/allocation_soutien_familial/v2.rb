class APIParticulier::CNAV::AllocationSoutienFamilial::V2 < APIParticulier::V2BaseSerializer
  attribute :status, if: -> { scope?(:allocation_soutien_familial) }

  attribute :dateDebut, if: -> { scope?(:allocation_soutien_familial) } do
    object.date_debut_droit
  end

  attribute :dateFin, if: -> { scope?(:allocation_soutien_familial) } do
    object.date_fin_droit
  end
end
