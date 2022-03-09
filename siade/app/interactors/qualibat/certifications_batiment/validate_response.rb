class QUALIBAT::CertificationsBatiment::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if empty_body?
  end

  private

  def empty_body?
    body.blank?
  end
end
