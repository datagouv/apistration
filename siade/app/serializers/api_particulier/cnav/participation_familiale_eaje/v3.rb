class APIParticulier::CNAV::ParticipationFamilialeEAJE::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :allocataires, if: -> { scope?(:cnav_participation_familiale_eaje_allocataires) }

  attribute :enfants, if: -> { scope?(:cnav_participation_familiale_eaje_enfants) }

  attribute :adresse, if: -> { scope?(:cnav_participation_familiale_eaje_adresse) }

  attribute :parametres_calcul_participation_familiale, if: -> { scope?(:cnav_participation_familiale_eaje_parametres_calcul) }
end
