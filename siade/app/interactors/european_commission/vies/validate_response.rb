class EuropeanCommission::VIES::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?
    unknown_provider_response! if invalid_json? || valid_tva_number_boolean.nil?

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

  private

  def valid_tva_number_boolean
    json_body['isValid']
  end
end
