class APIParticulier::CNAV::FoyerRSASerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :beneficiaires, if: -> { scope?(:cnav_foyer_rsa_beneficiaires) }

  attribute :personnes_a_charge, if: -> { scope?(:cnav_foyer_rsa_personnes_a_charge) }
end
