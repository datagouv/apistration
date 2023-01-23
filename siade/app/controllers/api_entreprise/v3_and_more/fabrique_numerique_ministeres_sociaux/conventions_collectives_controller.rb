class APIEntreprise::V3AndMore::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
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
end
