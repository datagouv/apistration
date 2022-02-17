class API::V3AndMore::Infogreffe::MandatairesSociauxController < API::V3AndMore::BaseController
  attr_reader :organizer

  def show
    authorize :entreprise

    @organizer = ::Infogreffe::MandatairesSociaux.call(params: organizer_params)

    if organizer.success?
      render json: serialize_payload, status: extract_http_code(organizer)
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

  def serialize_payload
    {
      data: serialize_collection(organizer.resource_collection),
      meta: organizer.meta
    }
  end

  def serialize_collection(resources)
    resources.map do |resource|
      dynamic_serializer_class(resource.type)
        .new(resource)
        .serializable_hash[:data]
    end
  end

  def dynamic_serializer_class(resource_type)
    dynamic_serializer_module(resource_type)
      .const_get("V#{api_version}")
  end

  def dynamic_serializer_module(resource_type)
    ::Infogreffe.const_get("#{resource_type}_serializer".classify)
  end

  def supported_version?
    dynamic_serializer_class('personne_physique')
    dynamic_serializer_class('personne_morale')
    true
  rescue ::NameError => _e
    false
  end
end
