class FranceConnect::DataFetcherThroughAccessToken::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! if invalid_json?

    handle_unauthorized if http_unauthorized?

    return if http_ok? && scopes_include_hub_identity?

    unknown_provider_response!
  end

  private

  def scopes_include_hub_identity?
    (hub_identity_scopes - scopes_flatten_without_aliases).empty?
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

  def scopes_flatten_without_aliases
    scopes = json_body['scope'].dup

    replace_scopes(scopes, 'identite_pivot', %w[profile birth])
    replace_scopes(scopes, 'profile', %w[given_name family_name birthdate gender])
    replace_scopes(scopes, 'birth', %w[birthplace birthcountry])

    scopes
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
