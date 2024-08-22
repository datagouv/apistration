class FranceConnect::V2::DataFetcherThroughAccessToken::BuildUser < FranceConnect::V2::DataFetcherThroughAccessToken::BuildDataFromAccessTokenInteractor
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
    json_body['token_introspection']['scope'].split
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
    Rails.application.config_for(:authorizations)[controller_name]
  end
end
