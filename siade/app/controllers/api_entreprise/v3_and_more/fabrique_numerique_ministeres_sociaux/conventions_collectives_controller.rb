class APIEntreprise::V3AndMore::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesController < APIEntreprise::V3AndMore::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors
    end
  end

  private

  def organizer_params
    {
      siret: params[:siret]
    }
  end

  def serializer_module
    ::APIEntreprise::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives)
  end
end
