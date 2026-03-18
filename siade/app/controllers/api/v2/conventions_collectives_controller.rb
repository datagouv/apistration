class API::V2::ConventionsCollectivesController < API::AuthenticateEntityController
  def show
    authorize :conventions_collectives

    retrieve_conventions = SIADE::V2::Retrievers::ConventionsCollectives.new(siret_from_params)
    retrieve_conventions.retrieve

    if retrieve_conventions.success?
      render json: ConventionCollectiveSerializer::V2.new(retrieve_conventions).as_json, status: retrieve_conventions.http_code
    else
      render_errors(retrieve_conventions)
    end
  end

  def siret_from_params
    params.require(:siret)
  end
end
