class API::V2::AbstractDGFIPController < API::V2::BaseController
  before_action :authorize_resource
  before_action :check_maintenance
  before_action :authenticate_dgfip_service

  def authorize_resource
    authorize resource_scope
  end

  def resource_scope
    fail NotImplementedError
  end

  def check_maintenance
    maintenance_service = MaintenanceService.new('DGFIP')

    return unless maintenance_service.on?

    render error_json(MaintenanceError.new('DGFIP'), status: 502)
  end

  def authenticate_dgfip_service
    dgfip_service.authenticate!

    unless dgfip_service.success?
      render_dgfip_authentication_failed
      false
    end
  rescue NoMethodError => e
    if no_cookie_on_provider_connection_refused_response?(e)
      render_dgfip_authentication_failed
      false
    else
      raise
    end
  end

  def render_dgfip_authentication_failed
    render json:   authenticate_errors,
      status: :bad_gateway
  end

  def dgfip_service
    @dgfip_service ||= AuthenticateDGFIPService.new
  end

  def authenticate_errors
    ErrorsSerializer.new(
      [
        ProviderAuthenticationError.new('DGFIP')
      ],
      format: error_format
    ).as_json
  end

  private

  def no_cookie_on_provider_connection_refused_response?(exception)
    exception.name == :cookie &&
      exception.receiver.instance_of?(SIADE::V2::Responses::ServiceUnavailable)
  end
end
