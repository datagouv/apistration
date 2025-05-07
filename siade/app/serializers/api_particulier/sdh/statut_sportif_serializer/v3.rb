class APIParticulier::SDH::StatutSportifSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :identite_sportif, if: -> { scope?(:sdh_statut_sportif_identite) }
  attribute :est_sportif_de_haut_niveau, if: -> { scope?(:sdh_statut_sportif_est_sportif_de_haut_niveau) }
  attribute :a_ete_sportif_de_haut_niveau, if: -> { scope?(:sdh_statut_sportif_a_ete_sportif_de_haut_niveau) }
  attribute :informations, if: -> { scope?(:sdh_statut_sportif_informations) }
  attribute :informations_historiques, if: -> { scope?(:sdh_statut_sportif_informations_historique) }
end
