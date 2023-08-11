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
    return all_api_particulier_scopes if use_mocked_data? && from_france_connect?

    json_body['scope']
  end

  def json_body
    @json_body ||= from_france_connect? ? JSON.parse(context.response.body) : context.mocked_data[:payload]
  end

  def from_france_connect?
    !Rails.env.staging? || context.mocked_data.nil?
  end

  def all_api_particulier_scopes
    [
      scopes_for('api_particulier/v2/cnous/student_scholarship'),
      scopes_for('api_particulier/v2/mesri/student_status'),
      %w[openid identite_pivot]
    ].flatten
  end

  def scopes_for(controller_name)
    Rails.application.config_for(:authorizations)[controller_name]
  end
end
