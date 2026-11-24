class ANTS::ExtraitImmatriculationVehicule::ValidateHTTPResponse < ValidateResponse
  declares_no_specific_errors!

  CODE_SUCCESS = 0
  CODE_NOT_FOUND = 60

  def call
    validate_http_status!
    validate_provider_code!
  end

  private

  def validate_http_status!
    rate_limited! if http_too_many_requests?

    provider_unavailable! if gateway_error?

    unknown_provider_response! if !http_ok? || invalid_json?
  end

  def validate_provider_code!
    resource_not_found! if not_found_in_response?

    unknown_provider_response! if unrecognized_code_in_response? || empty_dossiers?
  end

  def gateway_error?
    http_provider_bad_gateway_error? || http_unavailable? || http_provider_timeout_error?
  end

  def empty_dossiers?
    json_body['listeDossiers'].blank?
  end

  def not_found_in_response?
    response_code == CODE_NOT_FOUND
  end

  def unrecognized_code_in_response?
    [CODE_SUCCESS, CODE_NOT_FOUND].exclude?(response_code)
  end

  def response_code
    json_body['code']
  end
end
