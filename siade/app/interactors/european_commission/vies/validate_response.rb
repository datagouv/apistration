class EuropeanCommission::VIES::ValidateResponse < ValidateResponse
  # rubocop:disable Metrics/CyclomaticComplexity
  def call
    unknown_provider_response! unless http_ok?

    provider_unavailable! if network_proxy_block?
    unknown_provider_response! if invalid_json?
    provider_rate_limiting_error! if vies_rate_limiting_error?
    provider_unavailable! if ms_unavailable?
    unknown_provider_response! if user_error_invalid? || valid_tva_number_boolean.nil?

    handle_valid_json
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def handle_valid_json
    case valid_tva_number_boolean
    when FalseClass
      make_payload_cacheable!
      resource_not_found!
    when TrueClass
      make_payload_cacheable!
    else
      unknown_provider_response!
    end
  end

  def provider_rate_limiting_error!
    fail_with_error!(build_error(ProviderRateLimitingError))
  end

  def vies_rate_limiting_error?
    ip_banned? || max_concurrent_request?
  end

  def ip_banned?
    json_body['userError'] == 'IP_BLOCKED'
  end

  def max_concurrent_request?
    json_body['userError'] == 'MS_MAX_CONCURRENT_REQ'
  end

  def user_error_invalid?
    %w[INVALID VALID].exclude?(json_body['userError'])
  end

  def ms_unavailable?
    country_provider_error == 'MS_UNAVAILABLE'
  end

  def country_provider_error
    json_body['userError']
  end

  def valid_tva_number_boolean
    json_body['isValid']
  end

  def network_proxy_block?
    body.include?('contact your network support team')
  end
end
