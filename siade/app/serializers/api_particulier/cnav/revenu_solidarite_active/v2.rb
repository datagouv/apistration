class APIParticulier::CNAV::RevenuSolidariteActive::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:revenu_solidarite_active) }
  end

  attribute :majoration, if: -> { scope?(:revenu_solidarite_active_majoration) }
end
