class FranceConnect::DataFetcherThroughAccessToken::BuildUser < ApplicationInteractor
  def call
    context.user = build_user
  end

  private

  def build_user
    JwtUser.new(
      uid: '99999999-9999-9999-9999-999999999999',
      scopes:,
      jti: '99999999-9999-9999-9999-999999999999',
      iat: Time.new(2022, 1, 1).to_i,
      exp: Time.new(2042, 1, 1).to_i
    )
  end

  def scopes
    return all_api_particulier_scopes if called_france_connect_in_staging?

    json_body['scope']
  end

  def json_body
    @json_body ||= from_france_connect? ? JSON.parse(context.response.body) : context.mocked_data[:payload]
  end

  def called_france_connect_in_staging?
    Rails.env.staging? && from_france_connect?
  end

  def from_france_connect?
    !Rails.env.staging? || context.mocked_data.nil?
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
