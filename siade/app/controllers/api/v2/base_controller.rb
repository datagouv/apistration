class API::V2::BaseController < ::API::AuthenticateEntityController
  rescue_from ::ProviderInMaintenance, with: :provider_in_maintenance

  protected

  def content_type_header
    'application/json'
  end

  def provider_in_maintenance(exception)
    render error_json(MaintenanceError.new(exception.provider_name), status: 502)
  end
end
