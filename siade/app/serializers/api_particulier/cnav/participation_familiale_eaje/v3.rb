class APIParticulier::CNAV::ParticipationFamilialeEAJE::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :allocataires, if: -> { scope?(:eaje_allocataires) }

  attribute :enfants, if: -> { scope?(:eaje_enfants) }

  attribute :adresse, if: -> { scope?(:eaje_adresse) }

  attribute :parametres_calcul_participation_familiale, if: -> { scope?(:eaje_parametres_calcul_participation_familiale) }
end
