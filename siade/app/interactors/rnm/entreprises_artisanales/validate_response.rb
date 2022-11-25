class RNM::EntreprisesArtisanales::ValidateResponse < ValidateResponse
  def call
    return if http_ok? && payload_present?

    if http_not_found?
      resource_not_found!
    else
      internal_server_error!
    end
  end

  private

  def payload_present?
    json_body['id'].present?
  rescue JSON::ParserError
    false
  end
end
