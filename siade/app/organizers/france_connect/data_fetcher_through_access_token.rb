class FranceConnect::DataFetcherThroughAccessToken < ApplicationOrganizer
  organize FranceConnect::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity
end
