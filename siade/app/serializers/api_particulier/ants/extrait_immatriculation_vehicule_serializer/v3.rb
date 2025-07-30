class APIParticulier::ANTS::ExtraitImmatriculationVehiculeSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite_particulier, if: -> { scope?(:ants_extrait_immatriculation_vehicule_identite_particulier) }
  attribute :adresse_particulier, if: -> { scope?(:ants_extrait_immatriculation_vehicule_adresse_particulier) }
  attribute :statut_rattachement, if: -> { scope?(:ants_extrait_immatriculation_vehicule_statut_rattachement) }
  attribute :donnees_immatriculation_vehicule, if: -> { scope?(:ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule) }
  attribute :caracteristiques_techniques_vehicule, if: -> { scope?(:ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule) }
end
