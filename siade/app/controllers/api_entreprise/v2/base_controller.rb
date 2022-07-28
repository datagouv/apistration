class APIEntreprise::V2::BaseController < ::APIEntrepriseController
  include OrganizersMethodsHelpers
  rescue_from ::ProviderInMaintenance, with: :provider_in_maintenance

  protected

  def provider_in_maintenance(exception)
    render error_json(MaintenanceError.new(exception.provider_name), status: 502)
  end
end
