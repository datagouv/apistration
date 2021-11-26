class API::V3AndMore::INPI::BrevetsController < API::V3AndMore::BaseController
  def show
    authorize :extrait_court_inpi

    organizer = ::INPI::Brevets.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource_collection).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::INPI::BrevetsSerializer
  end
end
