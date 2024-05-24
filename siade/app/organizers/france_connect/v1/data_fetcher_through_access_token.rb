class FranceConnect::V1::DataFetcherThroughAccessToken < RetrieverOrganizer
  organize FranceConnect::V1::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::V1::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::V1::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::V1::DataFetcherThroughAccessToken::BuildServiceUserIdentity,
    FranceConnect::V1::DataFetcherThroughAccessToken::BuildClientAttributes

  def provider_name
    'FranceConnect'
  end
end
