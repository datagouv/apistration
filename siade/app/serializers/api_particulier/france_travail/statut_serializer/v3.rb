class APIParticulier::FranceTravail::StatutSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identifiant, if: -> { scope?(:pole_emploi_identifiant) }
  attribute :identite, if: -> { scope?(:pole_emploi_identite) }
  attribute :contact, if: -> { scope?(:pole_emploi_contact) }
  attribute :inscription, if: -> { scope?(:pole_emploi_inscription) }
  attribute :adresse, if: -> { scope?(:pole_emploi_adresse) }
end
