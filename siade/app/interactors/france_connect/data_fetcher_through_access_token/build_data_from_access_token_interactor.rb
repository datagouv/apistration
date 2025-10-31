class FranceConnect::DataFetcherThroughAccessToken::BuildDataFromAccessTokenInteractor < ApplicationInteractor
  protected

  def json_body
    @json_body ||= from_france_connect? ? context.json_body : context.mocked_data[:payload]
  end

  def from_france_connect?
    !use_mocked_data? || context.mocked_data.nil?
  end
end
