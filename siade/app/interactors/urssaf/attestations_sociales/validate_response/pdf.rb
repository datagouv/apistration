class URSSAF::AttestationsSociales::ValidateResponse::PDF < ValidateResponse
  def call
    context.decoded_body = Base64.strict_decode64(context.response.body)

    URSSAFAttestationVigilanceExtractor.new(context.decoded_body).perform
  rescue ArgumentError
    handle_potential_soft_error
  rescue URSSAFAttestationVigilanceExtractor::InvalidFile
    unknown_provider_response!
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
