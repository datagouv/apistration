class FranceConnect::V1::DataFetcherThroughAccessToken::BuildDataFromAccessTokenInteractor < ApplicationInteractor
  protected

  def json_body
    @json_body ||= from_france_connect? ? JSON.parse(context.response.body) : context.mocked_data[:payload]
  end

  def from_france_connect?
    !use_mocked_data? || context.mocked_data.nil?
  end
end
