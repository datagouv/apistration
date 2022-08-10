class FranceConnectDataFetcherThroughAccessToken::BuildServiceUserIdentity < ApplicationInteractor
  def call
    context.service_user_identity = Resource.new(json_body['identity'])
  end

  private

  def json_body
    @json_body ||= JSON.parse(context.response.body)
  end
end
