class APIParticulier::FranceTravail::IndemnitesSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identifiant
  attribute :paiements, if: -> { scope?(:pole_emploi_paiements) }
end
