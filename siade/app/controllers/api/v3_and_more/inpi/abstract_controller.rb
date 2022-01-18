class API::V3AndMore::INPI::AbstractController < API::V3AndMore::BaseController
  attr_reader :organizer

  def call(organizer_klass)
    authorize :extrait_court_inpi

    @organizer = organizer_klass.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource_collection, options).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def organizer_klass
    raise ::NotImplementedError
  end

  def organizer_params
    {
      siren: params.require(:siren),
      limit: 5
    }
  end

  def options
    {
      is_collection: true,
      meta: organizer.meta
    }
  end
end
