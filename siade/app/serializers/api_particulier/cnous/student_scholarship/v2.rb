class APIParticulier::CNOUS::StudentScholarship::V2 < APIParticulier::V2BaseSerializer
  # rubocop:disable Naming/VariableNumber
  %i[
    nom
    prenom
    prenom2
    dateNaissance
    lieuNaissance
    sexe
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:cnous_identite) }
  end
  # rubocop:enable Naming/VariableNumber

  attribute :email, if: -> { scope?(:cnous_email) }

  attribute :boursier, if: -> { scope?(:cnous_statut_boursier) }

  attribute :echelonBourse, if: -> { scope?(:cnous_echelon_bourse) }

  %i[
    statut
    statutLibelle
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:cnous_statut_bourse) }
  end

  %i[
    dateDeRentree
    dureeVersement
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:cnous_periode_versement) }
  end

  %i[
    villeEtudes
    etablissement
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:cnous_ville_etudes) }
  end
end
