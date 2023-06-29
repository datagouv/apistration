class QUALIBAT::CertificationsBatiment::ValidateResponse < ValidateResponse
  def call
    internal_server_error! if http_internal_error?
    resource_not_found! if http_not_found? || json_has_errors?
    unknown_provider_response! if empty_body?
  end

  private

  def empty_body?
    body.empty?
  end

  def json_has_errors?
    json_valid? && json_body['status_code'] == 404
  end

  def json_valid?
    !invalid_json?
  end
end
