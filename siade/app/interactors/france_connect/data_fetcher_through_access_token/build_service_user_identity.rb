class FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity < ApplicationInteractor
  def call
    context.service_user_identity = Resource.new(json_body['identity'])
  end

  private

  def json_body
    @json_body ||= from_france_connect? ? JSON.parse(context.response.body) : context.mocked_data[:payload]
  end

  def from_france_connect?
    !Rails.env.staging? || context.mocked_data.nil?
  end
end
