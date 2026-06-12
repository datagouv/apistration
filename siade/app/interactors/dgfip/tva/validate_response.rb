class DGFIP::TVA::ValidateResponse < DGFIP::ValidateResponse
  declares_no_specific_errors!

  def call
    return provider_unavailable! if http_not_found?
    return unknown_provider_response! unless http_ok?
    return unknown_provider_response! if invalid_json?

    case json_body
    in Hash => h if h['data'].respond_to?(:each)
      handle_data_response
    else
      unknown_provider_response!
    end
  end

  private

  def handle_data_response
    make_payload_cacheable!
    resource_not_found! if json_body['data'].empty?
  end
end
