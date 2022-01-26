class API::V3AndMore::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesController < API::V3AndMore::BaseController
  def show
    authorize :conventions_collectives

    organizer = ::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource_collection, options(organizer)).serializable_hash,
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

  def options(organizer)
    {
      is_collection: true,
      meta: organizer.meta
    }
  end

  def serializer_module
    ::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer
  end
end
