class APIParticulier::MEN::ScolaritesSerializer::V5 < APIParticulier::MEN::ScolaritesSerializer::V4
  attribute :regime_pensionnat, if: -> { scope?(:men_regime_pensionnat) }
end
