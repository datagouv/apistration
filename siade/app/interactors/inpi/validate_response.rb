class INPI::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! if invalid_json?

    resource_not_found! unless payload_has_results?

    return if http_ok? && payload_has_valid_results?

    unknown_provider_response!
  end

  private

  def payload_has_results?
    json_body['results'].any?
  end

  def payload_has_valid_results?
    payload_has_results? &&
      json_body['results'].first.try(:[], 'fields').any?
  end
end
