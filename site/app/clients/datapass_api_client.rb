require 'faraday'

class DatapassAPIClient
  class Error < StandardError
    attr_reader :status, :errors

    def initialize(message = nil, status: nil, errors: [])
      super(message)
      @status = status
      @errors = errors
    end
  end

  class Unauthorized < Error; end
  class NotFound < Error; end
  class UnprocessableEntity < Error; end

  def create_demande(attributes)
    request { http_connection.post('demandes', { demande: attributes }) }
  end

  def get_demande(id)
    request { http_connection.get("demandes/#{id}") }
  end

  def update_demande(id, data)
    request { http_connection.patch("demandes/#{id}", { demande: { data: } }) }
  end

  def list_demandes(siret: nil, state: nil, limit: nil, offset: nil)
    request { http_connection.get('demandes', { siret:, state:, limit:, offset: }.compact) }
  end

  private

  def request
    yield.body
  rescue Faraday::UnauthorizedError => e
    DatapassAPIAuthentication.invalidate_token_cache!
    raise build_error(Unauthorized, e)
  rescue Faraday::ForbiddenError => e
    raise build_error(Unauthorized, e)
  rescue Faraday::ResourceNotFound => e
    raise build_error(NotFound, e)
  rescue Faraday::UnprocessableEntityError => e
    raise build_error(UnprocessableEntity, e)
  rescue Faraday::Error => e
    raise build_error(Error, e)
  end

  def build_error(error_class, faraday_error)
    error_class.new(
      faraday_error.message,
      status: faraday_error.response_status,
      errors: Array(faraday_error.response_body.try(:dig, 'errors'))
    )
  end

  def http_connection
    Faraday.new(url: AdminApientreprise.credentials[:datapass_api][:url]) do |conn|
      conn.request :authorization, 'Bearer', -> { DatapassAPIAuthentication.new.access_token }
      conn.request :json
      conn.request :retry, max: 2
      conn.response :raise_error
      conn.response :json
      conn.options.timeout = 5
    end
  end
end
