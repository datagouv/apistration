class DGFIP::SituationIR::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    resource_not_found! if not_found?
    invalid_spi_code! if invalid_spi_code?

    unknown_provider_response!
  end

  private

  def not_found?
    [204, 403, 404, 410].include?(http_code)
  end

  def invalid_spi_code?
    valid_json? &&
      json_body['erreur'] &&
      json_body['erreur']['message'] == 'format SPI incorrect'
  end

  def invalid_spi_code!
    fail_with_error!(::UnprocessableEntityError.new(:tax_number))
  end
end
