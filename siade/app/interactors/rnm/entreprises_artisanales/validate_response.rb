class RNM::EntreprisesArtisanales::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && payload_present?

    if http_not_found?
      resource_not_found!
    else
      invalid_provider_response!
    end
  end

  private

  def http_ok?
    http_code == 200
  end

  def http_not_found?
    http_code == 404
  end

  def payload_present?
    json_body['id'].present?
  rescue JSON::ParserError
    false
  end
end
