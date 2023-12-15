class FranceConnect::DataFetcherThroughAccessToken::BuildClientAttributes < ApplicationInteractor
  def call
    context.client_attributes = Resource.new(json_body['client'])
  end

  private

  def json_body
    @json_body ||= from_france_connect? ? JSON.parse(context.response.body) : context.mocked_data[:payload]
  end

  def from_france_connect?
    !Rails.env.staging? || context.mocked_data.nil?
  end
end
