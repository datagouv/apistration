class FranceConnect::V1::DataFetcherThroughAccessToken::BuildUser < FranceConnect::V1::BuildDataFromAccessTokenInteractor
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
    return all_api_particulier_scopes if called_france_connect_in_staging?

    json_body['scope']
  end

  def called_france_connect_in_staging?
    Rails.env.staging? && from_france_connect?
  end

  def all_api_particulier_scopes
    [
      Scope.all_for_api('api_particulier'),
      %w[openid identite_pivot]
    ].flatten
  end

  def scopes_for(controller_name)
    Rails.application.config_for(:authorizations)[controller_name]
  end
end
