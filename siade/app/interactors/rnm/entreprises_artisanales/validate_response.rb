class RNM::EntreprisesArtisanales::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && payload_present?

    invalid_provider_response!
  end

  private

  def http_ok?
    http_code == 200
  end

  def payload_present?
    json_body['id'].present?
  rescue JSON::ParserError
    false
  end
end
