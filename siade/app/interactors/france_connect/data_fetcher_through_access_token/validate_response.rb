class FranceConnect::DataFetcherThroughAccessToken::ValidateResponse < ValidateResponse
  def call
    handle_invalid_token_error if [400, 401].include?(http_code)
    unknown_provider_response! if invalid_json?
    fail_for_insufficient_privileges! unless scopes_include_hub_identity?

    return if http_ok? && scopes_include_hub_identity?

    unknown_provider_response!
  end

  private

  def use_mocked_data?
    context.mocked_data.present?
  end

  def scopes_include_hub_identity?
    json_body['scope'].present? &&
      (hub_identity_scopes - scopes_flatten_without_aliases).empty?
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

  def fail_for_insufficient_privileges!
    fail_with_error!(InvalidFranceConnectAccessTokenError.new(:missing_hub_identity_scope, scopes: json_body['scope']))
  end

  def scopes_flatten_without_aliases
    @scopes_flatten_without_aliases ||= begin
      scopes = json_body['scope'].dup

      replace_scopes(scopes, 'identite_pivot', %w[profile birth])
      replace_scopes(scopes, 'profile', %w[given_name family_name birthdate gender])
      replace_scopes(scopes, 'birth', %w[birthplace birthcountry])

      scopes
    end
  end

  def replace_scopes(scopes, from_scope, to_scopes)
    return unless scopes.include?(from_scope)

    scopes.delete(from_scope)
    scopes.concat(to_scopes)
  end

  def hub_identity_scopes
    %w[
      family_name
      given_name
      gender
      birthdate
      birthplace
      birthcountry
    ]
  end

  def error_message
    json_body['message']
  end
end
