class APIParticulier::MEN::ScolaritesSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite, if: -> { scope?(:men_statut_identite) }
  %i[
    code_etablissement
    annee_scolaire
    est_scolarise
    status_eleve
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:men_statut_scolarite) }
  end

  attribute :est_boursier, if: -> { scope?(:men_statut_boursier) }
  attribute :echelon_bourse, if: -> { scope?(:men_statut_boursier) && scope?(:men_echelon_bourse) }
end
