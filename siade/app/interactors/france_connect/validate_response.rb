class FranceConnect::ValidateResponse < ValidateResponse
  def call
    handle_invalid_token_error if [400, 401].include?(http_code)
    unknown_provider_response! if invalid_json?
    fail_for_insufficient_privileges! unless scopes_include_hub_identity?

    return if http_ok? && scopes_include_hub_identity?

    unknown_provider_response!
  end

  protected

  def scopes
    NotImplementedError
  end

  def use_mocked_data?
    context.mocked_data.present?
  end

  def scopes_include_hub_identity?
    hub_identity_scopes & scopes_flatten_without_aliases == hub_identity_scopes
  end

  def scopes_flatten_without_aliases
    @scopes_flatten_without_aliases ||= begin
      flattened_scopes = scopes.dup

      replace_scopes(flattened_scopes, 'identite_pivot', %w[profile birth])
      replace_scopes(flattened_scopes, 'profile', %w[given_name family_name birthdate gender])
      replace_scopes(flattened_scopes, 'birth', %w[birthplace birthcountry])

      flattened_scopes
    end
  end

  def fail_for_insufficient_privileges!
    fail_with_error!(InvalidFranceConnectAccessTokenError.new(:missing_hub_identity_scope, scopes:))
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
end
