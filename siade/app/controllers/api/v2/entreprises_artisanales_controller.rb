class API::V2::EntreprisesArtisanalesController < API::AuthenticateEntityController
  def show
    authorize :entreprise_artisanale

    retrieve_entreprise = SIADE::V2::Retrievers::EntreprisesArtisanales.new(request_params)
    retrieve_entreprise.retrieve

    if retrieve_entreprise.success?
      render json: EntrepriseArtisanaleSerializer::V2.new(retrieve_entreprise).as_json,
        status: retrieve_entreprise.http_code
    else
      render_errors(retrieve_entreprise, gateway_error: true)
    end
  end

  private

  def request_params
    params.require(:siren)
  end
end
