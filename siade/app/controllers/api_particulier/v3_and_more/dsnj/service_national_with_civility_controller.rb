class APIParticulier::V3AndMore::DSNJ::ServiceNationalWithCivilityController < APIParticulier::V3AndMore::BaseController
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
    civility_parameters.merge(
      prenoms: civility_parameters[:prenoms]&.map(&:capitalize),
      nom_naissance: civility_parameters[:nom_naissance]&.upcase,
      code_cog_insee_commune_naissance:
    )
  end

  def serializer_module
    ::APIParticulier::DSNJ::ServiceNationalSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DSNJ::ServiceNational)
  end

  def code_cog_insee_commune_naissance
    return nil if params[:code_cog_insee_pays_naissance].to_s != '99100'

    params[:code_cog_insee_commune_naissance]
  end
end
