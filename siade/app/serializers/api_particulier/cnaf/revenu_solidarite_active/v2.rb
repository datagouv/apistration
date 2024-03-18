class APIParticulier::CNAF::RevenuSolidariteActive::V2 < APIParticulier::V2BaseSerializer
  %i[
    status
    majoration
    dateDebut
    dateFin
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:revenu_solidarite_active) }
  end
end
