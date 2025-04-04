class APIParticulier::CNAV::ParticipationFamilialeAEJE::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :allocataires, if: -> { scope?(:aeje_allocataires) }

  attribute :enfants, if: -> { scope?(:aeje_enfants) }

  attribute :adresse, if: -> { scope?(:aeje_adresse) }

  attribute :parametres_calcul_participation_familiale, if: -> { scope?(:aeje_parametres_calcul_participation_familiale) }
end
