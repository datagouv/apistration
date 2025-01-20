class FranceConnect::V1::DataFetcherThroughAccessToken::ValidateResponse < FranceConnect::ValidateResponse
  protected

  def scopes
    json_body['scope'].presence
  end

  def handle_invalid_token_error
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

  def params_to_verify # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
    {
      nom_naissance: json_body['identity']['family_name'],
      prenoms: json_body['identity']['given_name']&.split,
      annee_date_naissance: json_body['identity']['birthdate']&.split('-')&.first,
      mois_date_naissance: json_body['identity']['birthdate']&.split('-')&.second,
      jour_date_naissance: json_body['identity']['birthdate']&.split('-')&.third
    }
  end
end
