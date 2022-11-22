class FranceConnect::DataFetcherThroughAccessToken < RetrieverOrganizer
  organize FranceConnect::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity

  def provider_name
    'FranceConnect'
  end
end
