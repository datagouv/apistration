class APIParticulier::V3AndMore::MEN::ScolaritesWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    organizer = retrieve_payload_data(::MEN::Scolarites)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def transcogage?
    false
  end

  def organizer_params
    civility_parameters
      .merge({
        annee_scolaire: params[:anneeScolaire],
        code_etablissement: params[:codeEtablissement],
        provider_api_version: 'v2'
      })
  end

  def serializer_module
    ::APIParticulier::MEN::ScolaritesSerializer
  end
end
