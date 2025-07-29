class APIParticulier::ANTS::DossierImmatriculationSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite, if: -> { scope?(:ants_dossier_immatriculation_identite) }
  attribute :adresse, if: -> { scope?(:ants_dossier_immatriculation_adresse) }
  attribute :statut_rattachement_vehicule, if: -> { scope?(:ants_dossier_immatriculation_statut_rattachement_vehicule) }
  attribute :extrait_immatriculation_vehicule, if: -> { scope?(:ants_dossier_immatriculation_extrait_immatriculation_vehicule) }
  attribute :extrait_caracteristiques_techniques_vehicule, if: -> { scope?(:ants_dossier_immatriculation_extrait_caracteristiques_techniques_vehicule) }
end
