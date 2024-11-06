class APIParticulier::CNOUS::StudentScholarship::V2 < APIParticulier::V2BaseSerializer
  attribute :nom, if: -> { scope?(:cnous_identite) } do
    object.identite[:nom]
  end

  attribute :prenom, if: -> { scope?(:cnous_identite) } do
    object.identite[:prenom]
  end

  attribute :prenom2, if: -> { scope?(:cnous_identite) } do
    object.identite[:prenom2]
  end

  attribute :dateNaissance, if: -> { scope?(:cnous_identite) } do
    object.identite[:date_naissance]
  end

  attribute :lieuNaissance, if: -> { scope?(:cnous_identite) } do
    object.identite[:lieu_naissance]
  end

  attribute :sexe, if: -> { scope?(:cnous_identite) } do
    object.identite[:sexe]
  end

  attribute :email, if: -> { scope?(:cnous_email) }

  attribute :boursier, if: -> { scope?(:cnous_statut_boursier) } do
    object.est_boursier
  end

  attribute :echelonBourse, if: -> { scope?(:cnous_echelon_bourse) } do
    object.echelon_bourse
  end

  attribute :statut, if: -> { scope?(:cnous_statut_bourse) } do
    object.statut_bourse[:code]
  end

  attribute :statutLibelle, if: -> { scope?(:cnous_statut_bourse) } do
    object.statut_bourse[:libelle]
  end

  attribute :dateDeRentree, if: -> { scope?(:cnous_periode_versement) } do
    object.periode_versement_bourse[:date_rentree]
  end

  attribute :dureeVersement, if: -> { scope?(:cnous_periode_versement) } do
    object.periode_versement_bourse[:duree]
  end

  attribute :villeEtudes, if: -> { scope?(:cnous_ville_etudes) } do
    object.etablissement_etudes[:nom_commune]
  end

  attribute :etablissement, if: -> { scope?(:cnous_ville_etudes) } do
    object.etablissement_etudes[:nom_etablissement]
  end
end
