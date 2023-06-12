class FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity < ApplicationInteractor
  def call
    context.service_user_identity = Resource.new(json_body['identity'])
  end

  private

  def json_body
    @json_body ||= use_mocked_data? ? context.mocked_data[:payload] : JSON.parse(context.response.body)
  end
end
