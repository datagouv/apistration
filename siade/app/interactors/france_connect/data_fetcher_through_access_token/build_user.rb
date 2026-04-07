class FranceConnect::DataFetcherThroughAccessToken::BuildUser < FranceConnect::DataFetcherThroughAccessToken::BuildDataFromAccessTokenInteractor
  def call
    context.user = build_user
  end

  private

  def build_user
    JwtUser.new(
      uid: JwtUser.france_connect_id,
      scopes:,
      jti: JwtUser.france_connect_id,
      iat: Time.new(2022, 1, 1).to_i,
      exp: Time.new(2042, 1, 1).to_i
    )
  end

  def scopes
    scopes = json_body['token_introspection']['scope'].split

    scopes = remove_api_identity_scopes(scopes) unless api_version.to_i == 2

    scopes
  end

  def called_france_connect_in_staging?
    Rails.env.staging? && from_france_connect?
  end

  def all_france_connect_scopes
    [
      Scope.all_for_api('api_particulier'),
      %w[openid identite_pivot]
    ].flatten
  end

  def scopes_for(controller_name)
    Scope.config[controller_name]
  end

  def remove_api_identity_scopes(scopes)
    scopes.reject { |scope| scope.include? '_identite' }
  end

  def api_version
    context.params[:api_version]
  end
end
