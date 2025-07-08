class FranceConnectOrganizerService
  attr_reader :token, :api_name, :api_version

  def initialize(token, api_name, api_version)
    @token = token
    @api_name = api_name
    @api_version = api_version
  end

  def fetch
    @organizer = FranceConnect::V2::DataFetcherThroughAccessToken.call(params: { token:, api_name:, api_version: }) if france_connect_v2_enabled?

    @organizer = FranceConnect::V1::DataFetcherThroughAccessToken.call(params: { token:, api_version: }) if call_v1?

    @organizer
  end

  private

  def call_v1?
    return false if @organizer&.success?

    !france_connect_v2_enabled? || @organizer.errors.any? do |error|
      error.kind == :unauthorized || Rails.env.staging?
    end
  end

  def france_connect_v2_enabled?
    Siade.credentials[:france_connect_v2_enabled]
  end
end
