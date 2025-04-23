class APIParticulier::MEN::ScolaritesSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite, if: -> { scope?(:men_statut_identite) }

  %i[
    annee_scolaire
    est_scolarise
    statut_eleve
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:men_statut_scolarite) }
  end

  attribute :etablissement, if: -> { scope?(:men_statut_etablissement) }
  attribute :module_elementaire_formation, if: -> { scope?(:men_statut_module_elementaire_formation) }
  attribute :est_boursier, if: -> { scope?(:men_statut_boursier) }
  attribute :echelon_bourse, if: -> { scope?(:men_echelon_bourse) }
end
