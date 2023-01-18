class APIEntreprise::V2::ExtraitsCourtsINPIController < APIEntreprise::V2::BaseController
  def show
    retrieve_extrait_court_inpi = SIADE::V2::Retrievers::ExtraitCourtINPI.new(siren).retrieve

    if retrieve_extrait_court_inpi.success?
      render json: APIEntreprise::ExtraitCourtINPISerializer.new(retrieve_extrait_court_inpi).as_json, status: retrieve_extrait_court_inpi.http_code
    else
      render_errors(retrieve_extrait_court_inpi)
    end
  end

  def siren
    params.require(:siren)
  end
end
