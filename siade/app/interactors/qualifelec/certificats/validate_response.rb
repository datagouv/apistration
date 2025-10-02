class Qualifelec::Certificats::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found? || siret_without_certificates?
    siret_without_certificates! if http_ok? && body == '[]'

    return if http_ok? && valid_json?

    unknown_provider_response!
  end

  protected

  def siret_without_certificates!
    fail_with_error!(build_error(::NotFoundError, 'Le SIRET existe chez Qualifelec mais ne possède pas de certificats Qualifelec.'))
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError))
  end

  def siret_without_certificates?
    body['code'] == 404
  end
end
