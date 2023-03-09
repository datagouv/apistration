class AuthenticateDGFIPService
  attr_accessor :user
  attr_reader :cookie, :errors, :http_code, :response, :retriever_authenticate

  def initialize
    @errors = []
  end

  def authenticate!
    retrieve_cookie
    self
  end

  def success?
    @errors.empty?
  end

  private

  def retrieve_cookie
    handle_maintenance

    @retriever_authenticate = SIADE::V2::Requests::AuthenticateDGFIP.new
    retriever_authenticate.perform

    @errors += retriever_authenticate.errors
    @response = retriever_authenticate.response
    @http_code = retriever_authenticate.response.http_code

    return unless success?

    @cookie = retriever_authenticate.cookie
  end

  def handle_maintenance
    return unless in_maintenance?

    raise ::ProviderInMaintenance, provider_name
  end

  def in_maintenance?
    MaintenanceService.new(provider_name).on?
  end

  def provider_name
    'DGFIP - Adélie'
  end
end
