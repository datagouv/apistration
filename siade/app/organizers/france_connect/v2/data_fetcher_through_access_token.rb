class FranceConnect::V2::DataFetcherThroughAccessToken < RetrieverOrganizer
  organize FranceConnect::V2::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::V2::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::V2::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::V2::DataFetcherThroughAccessToken::BuildServiceUserIdentity,
    FranceConnect::V2::DataFetcherThroughAccessToken::BuildClientAttributes

  def provider_name
    'FranceConnect v2'
  end
end
