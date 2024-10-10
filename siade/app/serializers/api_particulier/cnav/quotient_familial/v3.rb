class APIParticulier::CNAV::QuotientFamilial::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :quotient_familial, if: -> { scope?(:cnaf_quotient_familial) }

  attribute :allocataires, if: -> { scope?(:cnaf_allocataires) }

  attribute :enfants, if: -> { scope?(:cnaf_enfants) }

  attribute :adresse, if: -> { scope?(:cnaf_adresse) }
end
