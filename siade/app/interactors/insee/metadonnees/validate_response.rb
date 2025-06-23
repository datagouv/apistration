class INSEE::Metadonnees::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && valid_json?

    resource_not_found! if http_not_found?

    unknown_provider_response!
  end

  private

  def valid_json?
    json_body.any? &&
      json_body[0]['code'].present?
  end
end
