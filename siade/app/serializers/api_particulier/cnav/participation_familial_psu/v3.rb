class APIParticulier::CNAV::ParticipationFamilialPSU::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :allocataires, if: -> { scope?(:psu_allocataires) }

  attribute :enfants, if: -> { scope?(:psu_enfants) }

  attribute :adresse, if: -> { scope?(:psu_adresse) }

  attribute :parametres_calcul_tarif, if: -> { scope?(:psu_parametres_calcul_tarif) }
end
