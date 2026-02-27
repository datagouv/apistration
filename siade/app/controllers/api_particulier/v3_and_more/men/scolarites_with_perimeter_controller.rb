class APIParticulier::V3AndMore::MEN::ScolaritesWithPerimeterController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    if organizer.success?
      render json: serialize_data,
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
        degre_etablissement: params[:degreEtablissement],
        codes_bcn_departements: params[:codesBcnDepartements],
        codes_bcn_regions: params[:codesBcnRegions],
        provider_api_version: 'v2'
      })
  end

  def serializer_module
    ::APIParticulier::MEN::ScolaritesSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::MEN::ScolaritesPerimetre)
  end
end
