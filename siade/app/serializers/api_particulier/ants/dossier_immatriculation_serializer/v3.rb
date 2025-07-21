class APIParticulier::ANTS::DossierImmatriculationSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :statut_demandeur, if: -> { scope?(:ants_dossier_immatriculation_statut_demandeur) }
  attribute :statut_location, if: -> { scope?(:ants_dossier_immatriculation_statut_demandeur) }
  attribute :identite_demandeur, if: -> { scope?(:ants_dossier_immatriculation_identite_demandeur) }
  attribute :immatriculation, if: -> { scope?(:ants_dossier_immatriculation_immatriculation) }
  attribute :vehicule, if: -> { scope?(:ants_dossier_immatriculation_vehicule) }
end
