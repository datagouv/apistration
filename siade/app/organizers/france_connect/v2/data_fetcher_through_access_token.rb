class FranceConnect::V2::DataFetcherThroughAccessToken < RetrieverOrganizer
  organize FranceConnect::V2::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::V2::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::V2::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::V2::DataFetcherThroughAccessToken::BuildServiceUserIdentity,
    FranceConnect::V2::DataFetcherThroughAccessToken::BuildClientAttributes

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
