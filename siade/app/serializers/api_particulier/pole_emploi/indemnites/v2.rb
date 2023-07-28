class APIParticulier::PoleEmploi::Indemnites::V2 < APIParticulier::V2BaseSerializer
  attribute :identifiant
  attribute :paiements, if: -> { scope?(:pole_emploi_paiements) }
end
