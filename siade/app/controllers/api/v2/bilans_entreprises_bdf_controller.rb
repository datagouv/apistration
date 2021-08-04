class API::V2::BilansEntreprisesBDFController < API::V2::BaseController
  before_action :check_maintenance

  def show
    authorize :bilans_entreprise_bdf

    retrieve_bilans_bdf = SIADE::V2::Retrievers::BilansEntreprisesBDF.new(siren)

    retrieve_bilans_bdf.retrieve

    if retrieve_bilans_bdf.success?
      render json: BilansEntrepriseBDFSerializer.new(retrieve_bilans_bdf).as_json, status: retrieve_bilans_bdf.http_code
    else
      render_errors(retrieve_bilans_bdf)
    end
  end

  private

  def check_maintenance
    maintenance_service = MaintenanceService.new('Banque de France')

    return unless maintenance_service.on?

    render error_json(MaintenanceError.new('Banque de France'), status: 502)
  end

  def siren
    params.require(:siren)
  end
end
