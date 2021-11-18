class API::V3AndMore::INSEE::UnitesLegalesDiffusablesController < API::V3AndMore::BaseController
  def show
    authorize :entreprise

    organizer = ::INSEE::UniteLegaleDiffusable.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource).serializable_hash,
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
    ::INSEE::UniteLegaleSerializer
  end
end
