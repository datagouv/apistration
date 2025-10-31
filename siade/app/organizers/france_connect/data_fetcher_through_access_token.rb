class FranceConnect::DataFetcherThroughAccessToken < RetrieverOrganizer
  organize FranceConnect::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity,
    FranceConnect::DataFetcherThroughAccessToken::BuildClientAttributes

  def provider_name
    'FranceConnect v2'
  end

  def errors_to_track
    context.errors
  end

  def track_error(error)
    monitoring_service.track_with_added_context(
      'error',
      'FranceConnect v2 error',
      {
        error: error.to_h
      }
    )
  end
end
