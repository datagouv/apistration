class APIParticulier::MEN::Scolarites::V2 < APIParticulier::V2BaseSerializer
  attribute :eleve, if: -> { scope?(:men_statut_scolarite) } do
    object.identite
  end

  %i[
    annee_scolaire
    est_scolarise
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:men_statut_scolarite) }
  end

  attribute :status_eleve, if: -> { scope?(:men_statut_scolarite) } do
    object.statut_eleve
  end

  attribute :code_etablissement do
    object.etablissement[:code_uai]
  end

  attribute :est_boursier, if: -> { scope?(:men_statut_boursier) }
  attribute :niveau_bourse, if: -> { scope?(:men_statut_boursier) && scope?(:men_echelon_bourse) } do
    object.echelon_bourse
  end
end
