class FranceConnectOrganizerService
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def fetch
    @organizer = FranceConnect::V2::DataFetcherThroughAccessToken.call(params: { token: })

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
