class INSEESireneAPIClient < AbstractINSEEAPIClient
  class EntityNotFoundError < StandardError; end

  def etablissement(siret:)
    retrying_once_with_a_fresh_token do
      http_connection.get(
        "https://api.insee.fr/api-sirene/prive/3.11/siret/#{siret}"
      ).body
    end
  rescue Faraday::ResourceNotFound => e
    raise EntityNotFoundError, "Etablissement with SIRET #{siret} not found: #{e.message}"
  end

  protected

  def http_connection
    super do |conn|
      conn.request :authorization, 'Bearer', -> { INSEEAPIAuthentication.new.access_token }
    end
  end

  private

  def retrying_once_with_a_fresh_token
    yield
  rescue Faraday::UnauthorizedError
    INSEEAPIAuthentication.invalidate_token_cache!

    yield
  end
end
