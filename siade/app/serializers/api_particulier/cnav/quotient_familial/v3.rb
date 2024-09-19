class APIParticulier::CNAV::QuotientFamilial::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :quotientFamilial, if: -> { scope?(:cnaf_quotient_familial) }
  attribute :mois, if: -> { scope?(:cnaf_quotient_familial) }
  attribute :annee, if: -> { scope?(:cnaf_quotient_familial) }
  attribute :regime, if: -> { scope?(:cnaf_quotient_familial) }
  attribute :annee_calcul, if: -> { scope?(:cnaf_quotient_familial) }
  attribute :mois_calcul, if: -> { scope?(:cnaf_quotient_familial) }

  attribute :allocataires, if: -> { scope?(:cnaf_allocataires) }

  attribute :enfants, if: -> { scope?(:cnaf_enfants) }

  attribute :adresse, if: -> { scope?(:cnaf_adresse) }
end
