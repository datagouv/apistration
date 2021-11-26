class INPI::Brevets::ValidateResponse < ValidateResponse
  def call
    check_body_integrity!

    return if http_ok? && payload_has_results?

    resource_not_found! unless payload_has_results?

    invalid_provider_response!
  end

  private

  def payload_has_results?
    json_body['results'].any?
  end

  def check_body_integrity!
    json_body
  rescue JSON::ParserError
    unknown_provider_response!
  end
end
