class APIParticulier::CNAV::AllocationAdulteHandicape::V2 < APIParticulier::V2BaseSerializer
  attribute :status, if: -> { scope?(:allocation_adulte_handicape) }

  attribute :dateDebut, if: -> { scope?(:allocation_adulte_handicape) } do
    object.date_debut_droit
  end
end
