class FranceConnect::V2::DataFetcherThroughAccessToken::ValidateResponse < FranceConnect::ValidateResponse
  protected

  def scopes
    json_body['token_introspection']['scope'].split
  end

  def handle_invalid_token_error
    case error_type
    when 'invalid_request'
      fail_with_error!(InvalidFranceConnectAccessTokenError.new(:malformed_token))
    when 'invalid_client'
      fail_with_error!(InvalidFranceConnectAccessTokenError.new(:not_found_or_expired))
    else
      unknown_provider_response!
    end
  end

  def error_type
    json_body['error']
  end
end
