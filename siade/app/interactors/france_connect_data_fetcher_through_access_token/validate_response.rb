class FranceConnectDataFetcherThroughAccessToken::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! if invalid_json?

    handle_unauthorized if http_unauthorized?

    return if http_ok? && scopes_include_hub_identity?

    unknown_provider_response!
  end

  private

  def scopes_include_hub_identity?
    json_body['scope'].include?('identite_pivot') || (
      json_body['scope'].include?('profile') &&
        json_body['scope'].include?('birth')
    )
  end

  def handle_unauthorized
    case error_message
    when /Malformed/
      fail_with_error!(InvalidFranceConnectAccessTokenError.new(:malformed_token))
    when 'token_not_found_or_expired'
      fail_with_error!(InvalidFranceConnectAccessTokenError.new(:not_found_or_expired))
    else
      unknown_provider_response!
    end
  end

  def error_message
    json_body['message']
  end
end
