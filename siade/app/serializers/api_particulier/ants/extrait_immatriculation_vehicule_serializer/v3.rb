class APIParticulier::ANTS::ExtraitImmatriculationVehiculeSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite, if: -> { scope?(:ants_extrait_immatriculation_vehicule_identite) }
  attribute :adresse, if: -> { scope?(:ants_extrait_immatriculation_vehicule_adresse) }
  attribute :statut_rattachement_vehicule, if: -> { scope?(:ants_extrait_immatriculation_vehicule_statut_rattachement_vehicule) }
  attribute :extrait_immatriculation_vehicule, if: -> { scope?(:ants_extrait_immatriculation_vehicule_extrait_immatriculation_vehicule) }
  attribute :extrait_caracteristiques_techniques_vehicule, if: -> { scope?(:ants_extrait_immatriculation_vehicule_extrait_caracteristiques_techniques_vehicule) }
end
