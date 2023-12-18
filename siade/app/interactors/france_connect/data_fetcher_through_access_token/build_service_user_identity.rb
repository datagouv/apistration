class FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity < FranceConnect::BuildDataFromAccessTokenInteractor
  def call
    context.service_user_identity = Resource.new(json_body['identity'])
  end
end
