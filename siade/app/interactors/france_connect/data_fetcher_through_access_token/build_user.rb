class FranceConnect::DataFetcherThroughAccessToken::BuildUser < ApplicationInteractor
  def call
    context.user = build_user
  end

  private

  def build_user
    JwtUser.new(
      uid: '99999999-9999-9999-9999-999999999999',
      scopes: json_body['scope'],
      jti: '99999999-9999-9999-9999-999999999999',
      iat: Time.new(2022, 1, 1).to_i,
      exp: Time.new(2042, 1, 1).to_i
    )
  end

  def json_body
    @json_body ||= use_mocked_data? ? context.mocked_data[:payload] : JSON.parse(context.response.body)
  end
end
