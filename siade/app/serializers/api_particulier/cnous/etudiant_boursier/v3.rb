class APIParticulier::CNOUS::EtudiantBoursier::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite, if: -> { scope?(:cnous_identite) }

  attribute :email, if: -> { scope?(:cnous_email) }

  attribute :est_boursier, if: -> { scope?(:cnous_statut_boursier) }

  attribute :echelon_bourse, if: -> { scope?(:cnous_echelon_bourse) }

  attribute :periode_versement_bourse, if: -> { scope?(:cnous_periode_versement) }

  attribute :etablissement_etudes, if: -> { scope?(:cnous_ville_etudes) }
end
