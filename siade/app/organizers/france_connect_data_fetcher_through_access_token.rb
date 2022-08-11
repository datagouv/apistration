class FranceConnectDataFetcherThroughAccessToken < ApplicationOrganizer
  organize FranceConnectDataFetcherThroughAccessToken::MakeRequest,
    FranceConnectDataFetcherThroughAccessToken::ValidateResponse,
    FranceConnectDataFetcherThroughAccessToken::BuildUser,
    FranceConnectDataFetcherThroughAccessToken::BuildServiceUserIdentity
end
