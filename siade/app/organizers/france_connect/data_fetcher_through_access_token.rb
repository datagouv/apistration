class FranceConnect::DataFetcherThroughAccessToken < RetrieverOrganizer
  organize FranceConnect::DataFetcherThroughAccessToken::MakeRequest,
    FranceConnect::DataFetcherThroughAccessToken::ValidateResponse,
    FranceConnect::DataFetcherThroughAccessToken::BuildUser,
    FranceConnect::DataFetcherThroughAccessToken::BuildServiceUserIdentity,
    FranceConnect::DataFetcherThroughAccessToken::BuildClientAttributes

  def provider_name
    'FranceConnect'
  end

  def errors_to_track
    context.errors.reject { |error| error.code == '50002' }
  end

  def track_error(error)
    error_hash = error.to_h
    monitoring_service.track_with_added_context(
      'error',
      "FranceConnect error: #{error_hash[:title]} (#{error_hash[:code]})",
      { error: error_hash }
    )
  end
end
