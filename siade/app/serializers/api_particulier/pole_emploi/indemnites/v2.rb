class APIParticulier::PoleEmploi::Indemnites::V2 < APIParticulier::V2BaseSerializer
  attribute :identifiant
  attribute :paiements, if: -> { scope?(:pole_emploi_paiements) } do
    object.paiements.map do |paiement|
      {
        date: paiement[:date_versement],
        montant: paiement[:montant_total],
        allocations: paiement[:montant_allocations],
        aides: paiement[:montant_aides],
        autres: paiement[:montant_autres]
      }
    end
  end
end
