class ANTS::ExtraitImmatriculationVehicule::ValidateHTTPResponse < ValidateResponse
  raises ANTSError, kind: :no_matching_identity

  CODE_SUCCESS = 0
  CODE_NOT_FOUND = 60
  CODE_IDENTITY_MISMATCH = 64

  def call
    unknown_provider_response! if http_internal_error?

    resource_not_found! if not_found_in_response?

    no_matching_identity! if identity_mismatch_in_response?

    unknown_provider_response! if unrecognized_code_in_response?
  end

  private

  def not_found_in_response?
    response_code == CODE_NOT_FOUND
  end

  def identity_mismatch_in_response?
    response_code == CODE_IDENTITY_MISMATCH
  end

  def unrecognized_code_in_response?
    [CODE_SUCCESS, CODE_NOT_FOUND, CODE_IDENTITY_MISMATCH].exclude?(response_code)
  end

  def response_code
    json_body['code']
  end

  def no_matching_identity!
    fail_with_error!(ANTSError.new(:no_matching_identity))
  end
end
