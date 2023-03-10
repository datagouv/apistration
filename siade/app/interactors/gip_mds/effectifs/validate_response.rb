class GIPMDS::Effectifs::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if [204, 404].include?(http_code)
    unknown_provider_response! if invalid_json?
    unknown_provider_response! unless all_required_regime_are_present?
    resource_not_found! unless at_least_one_effectif_transmitted?
  end

  private

  def all_required_regime_are_present?
    (json_body.pluck('source') & required_regimes).sort == required_regimes
  end

  def required_regimes
    @required_regimes ||= %w[RA RG].sort.freeze
  end

  def at_least_one_effectif_transmitted?
    json_body.find { |e| e['effectifs'] != 'NC' }
  end
end
