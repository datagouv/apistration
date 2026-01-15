class URSSAF::AttestationsSociales::ValidateResponse::PDF < ValidateResponse
  def call
    Base64.strict_decode64(context.response.body)
  rescue ArgumentError
    handle_potential_soft_error
  end

  private

  def handle_potential_soft_error
    return if json_errors.any? { |error| error[:code] == 'FUNC502' }

    unknown_provider_response!
  rescue JSON::ParserError
    unknown_provider_response!
  end

  def json_errors
    @json_errors ||= JSON.parse(
      body,
      symbolize_names: true
    )
  end
end
