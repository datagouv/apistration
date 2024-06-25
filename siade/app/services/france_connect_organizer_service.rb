class FranceConnectOrganizerService
  attr_reader :token, :api_name

  def initialize(token, api_name)
    @token = token
    @api_name = api_name
  end

  def fetch
    @organizer = FranceConnect::V2::DataFetcherThroughAccessToken.call(params: { token:, api_name: })

    @organizer = FranceConnect::V1::DataFetcherThroughAccessToken.call(params: { token: }) if call_v1?

    @organizer
  end

  private

  def call_v1?
    @organizer.errors.any? do |error|
      error.kind == :unauthorized
    end
  end
end
