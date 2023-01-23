class APIEntreprise::V3AndMore::INSEE::UnitesLegalesDiffusablesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::INSEE::UniteLegaleDiffusable)

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
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::UniteLegaleSerializer
  end
end
