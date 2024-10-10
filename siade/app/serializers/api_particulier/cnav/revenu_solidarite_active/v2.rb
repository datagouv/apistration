class APIParticulier::CNAV::RevenuSolidariteActive::V2 < APIParticulier::V2BaseSerializer
  attribute :status, if: -> { scope?(:revenu_solidarite_active) }

  attribute :dateDebut, if: -> { scope?(:revenu_solidarite_active) } do
    object.date_debut_droit
  end

  attribute :dateFin, if: -> { scope?(:revenu_solidarite_active) } do
    object.date_fin_droit
  end

  attribute :majoration, if: -> { scope?(:revenu_solidarite_active_majoration) } do
    object.avec_majoration
  end
end
