class QUALIBAT::CertificationsBatiment::ValidateResponse < ValidateResponse
  def call
    internal_server_error! if http_internal_error?
    resource_not_found! if http_not_found?
    unknown_provider_response! if empty_body?
  end

  private

  def empty_body?
    body.blank?
  end
end
