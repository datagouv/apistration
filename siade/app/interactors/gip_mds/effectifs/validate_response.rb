class GIPMDS::Effectifs::ValidateResponse < ValidateResponse
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
  def call
    resource_not_found! if [204, 404].include?(http_code)
    temporary_credentials_error! if temporary_credentials_error?
    quota_error! if quota_error?
    internal_server_error! if internal_server_error?
    unknown_provider_response! if invalid_json?
    ko_technique! if ko_technique?
    unknown_provider_response! unless all_required_regime_are_present?
    resource_not_found! unless at_least_one_effectif_transmitted?
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize

  private

  def all_required_regime_are_present?
    (json_body.pluck('source') & required_regimes).sort == required_regimes
  end

  def internal_server_error?
    http_code == 500
  end

  def required_regimes
    @required_regimes ||= %w[RA RG].sort.freeze
  end

  def at_least_one_effectif_transmitted?
    json_body.find { |e| e['effectifs'] != 'NC' }
  end

  def temporary_credentials_error?
    [401, 403].include?(http_code)
  end

  def temporary_credentials_error!
    context.errors << GIPMDSError.new(:temporary_credentials_error)
    context.fail!
  end

  def quota_error?
    http_code == 429
  end

  def quota_error!
    retry_date_string = Rack::Utils.parse_nested_query(response.body)['nextAccessTime']
    retry_date = DateTime.parse(retry_date_string)

    MonitoringService.instance.track_with_added_context(
      'warning',
      '[GIP-MDS] Quota exceeded',
      { next_access_time: retry_date_string }
    )

    context.errors << GIPMDSError.new(:quota_error, retry_date)
    context.fail!
  end

  def ko_technique?
    json_body.is_a?(Hash) &&
      json_body.key?('code') &&
      json_body['code'] == 'KO_TECHNIQUE'
  end

  def ko_technique!
    context.errors << GIPMDSError.new(:ko_technique)
    context.fail!
  end
end
