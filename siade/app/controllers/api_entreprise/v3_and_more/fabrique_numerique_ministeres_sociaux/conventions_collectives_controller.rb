class APIEntreprise::V3AndMore::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesController < APIEntreprise::V3AndMore::BaseController
  def show
    authorize :conventions_collectives

    organizer = ::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data).serializable_hash,
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
