class APIParticulier::CNAV::RevenuSolidariteActive::V3 < APIParticulier::V3AndMore::BaseSerializer
  %i[
    est_beneficiaire
    date_debut_droit
    date_fin_droit
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:revenu_solidarite_active) }
  end

  attribute :avec_majoration, if: -> { scope?(:revenu_solidarite_active_majoration) }
end
