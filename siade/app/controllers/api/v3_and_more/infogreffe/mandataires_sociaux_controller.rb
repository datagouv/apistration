class API::V3AndMore::Infogreffe::MandatairesSociauxController < API::V3AndMore::BaseController
  attr_reader :organizer

  def show
    authorize :entreprise

    @organizer = ::Infogreffe::MandatairesSociaux.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource_collection, options).serializable_hash,
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
    ::Infogreffe::MandatairesSociauxSerializer
  end

  def options
    {
      is_collection: true,
      meta: organizer.meta
    }
  end
end
