class FranceConnect::DataFetcherThroughAccessToken::BuildClientAttributes < FranceConnect::BuildDataFromAccessTokenInteractor
  def call
    context.client_attributes = Resource.new(json_body['client'])
  end
end
