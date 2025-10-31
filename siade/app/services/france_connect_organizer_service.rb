class FranceConnectOrganizerService
  attr_reader :token, :api_name, :api_version

  def initialize(token, api_name, api_version)
    @token = token
    @api_name = api_name
    @api_version = api_version
  end

  def fetch
    FranceConnect::V2::DataFetcherThroughAccessToken.call(params: { token:, api_name:, api_version: })
  end
end
