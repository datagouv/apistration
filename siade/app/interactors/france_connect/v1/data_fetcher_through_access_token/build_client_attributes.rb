class FranceConnect::V1::DataFetcherThroughAccessToken::BuildClientAttributes < FranceConnect::V1::DataFetcherThroughAccessToken::BuildDataFromAccessTokenInteractor
  def call
    context.client_attributes = Resource.new(json_body['client'].merge(sub: nil))
  end
end
