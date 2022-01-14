class API::V3AndMore::INPI::LatestModelesController < API::V3AndMore::INPI::LatestOpenDataController
  def show
    authorize :extrait_court_inpi

    organizer = ::INPI::Modeles.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource_collection).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def serializer_module
    ::INPI::ModelesSerializer
  end
end
