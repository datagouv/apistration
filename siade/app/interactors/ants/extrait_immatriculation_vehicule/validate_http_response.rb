class ANTS::ExtraitImmatriculationVehicule::ValidateHTTPResponse < ValidateResponse
  declares_no_specific_errors!

  CODE_SUCCESS = 0
  CODE_NOT_FOUND = 60

  def call
    unknown_provider_response! if http_internal_error?

    resource_not_found! if not_found_in_response?

    unknown_provider_response! if unrecognized_code_in_response?
  end

  private

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
