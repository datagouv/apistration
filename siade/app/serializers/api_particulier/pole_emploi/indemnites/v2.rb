class APIParticulier::PoleEmploi::Indemnites::V2 < APIParticulier::V2BaseSerializer
  attribute :identifiant, if: -> { scope?(:pole_emploi_identite) }
  attribute :paiements, if: -> { scope?(:pole_emploi_paiements) }
end
