class FranceConnect::V1::DataFetcherThroughAccessToken < RetrieverOrganizer
  organize FranceConnect::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity,
    FranceConnect::DataFetcherThroughAccessToken::BuildClientAttributes

  def provider_name
    'FranceConnect'
  end
end
