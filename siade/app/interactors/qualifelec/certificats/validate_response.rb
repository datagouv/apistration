class Qualifelec::Certificats::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found? || siret_without_certificates?
    return if http_ok? && valid_json?

    unknown_provider_response!
  end

  protected

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError))
  end

  def siret_without_certificates?
    body['code'] == 404
  end
end
