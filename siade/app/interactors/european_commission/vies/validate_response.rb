class EuropeanCommission::VIES::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    unknown_provider_response! if invalid_json? || valid_tva_number_boolean.nil?

    handle_valid_json
  end

  private

  def handle_valid_json
    provider_rate_limiting_error! if ip_banned?
    provider_unavailable! if country_provider_error == 'MS_UNAVAILABLE'

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

  def ip_banned?
    json_body['userError'] == 'IP_BLOCKED'
  end

  def country_provider_error
    json_body['userError']
  end

  def valid_tva_number_boolean
    json_body['isValid']
  end
end
