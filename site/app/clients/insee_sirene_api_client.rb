class INSEESireneAPIClient < AbstractINSEEAPIClient
  class EntityNotFoundError < StandardError; end
  class InvalidPayloadError < StandardError; end

  REJECTED_BEARER_MESSAGE = 'INSEE rejected the bearer, reauthenticating'.freeze
  REJECTED_BEARER_CACHE_KEY = 'insee/rejected_bearer'.freeze
  REJECTED_BEARER_REPORT_INTERVAL = 5.minutes

  def etablissement(siret:)
    payload = retrying_once_with_a_fresh_token do
      http_connection.get(
        "https://api.insee.fr/api-sirene/prive/3.11/siret/#{siret}"
      ).body
    end

    Hash.try_convert(payload) || raise(InvalidPayloadError, "Etablissement with SIRET #{siret} is not a JSON object")
  rescue Faraday::ResourceNotFound => e
    raise EntityNotFoundError, "Etablissement with SIRET #{siret} not found: #{e.message}"
  rescue Faraday::ParsingError => e
    raise InvalidPayloadError, "Etablissement with SIRET #{siret} is not a valid JSON: #{e.message}"
  end

  protected

  def http_connection
    super do |conn|
      conn.request :authorization, 'Bearer', -> { bearer_token }
    end
  end

  private

  def bearer_token
    @bearer_token = INSEEAPIAuthentication.new.access_token
  end

  def retrying_once_with_a_fresh_token
    yield
  rescue Faraday::UnauthorizedError
    report_rejected_bearer!

    INSEEAPIAuthentication.invalidate_token_cache!(@bearer_token)

    yield
  end

  def report_rejected_bearer!
    already_reported = Rails.cache.write(
      REJECTED_BEARER_CACHE_KEY,
      true,
      expires_in: REJECTED_BEARER_REPORT_INTERVAL,
      unless_exist: true
    ) == false

    return if already_reported

    MonitoringService.instance.track(REJECTED_BEARER_MESSAGE, level: :warning)
  end
end
