class FranceConnectOrganizerService
  attr_reader :token, :api_name

  def initialize(token, api_name)
    @token = token
    @api_name = api_name
  end

  def fetch
    @organizer = FranceConnect::V2::DataFetcherThroughAccessToken.call(params: { token:, api_name: }) if france_connect_v2_enabled?

    @organizer = FranceConnect::V1::DataFetcherThroughAccessToken.call(params: { token: }) if call_v1?

    @organizer
  end

  private

  def call_v1?
    !france_connect_v2_enabled? || @organizer.errors.any? do |error|
      error.kind == :unauthorized || Rails.env.staging?
    end
  end

  def france_connect_v2_enabled?
    Siade.credentials[:france_connect_v2_enabled]
  end
end
