class APIEntreprise::V3AndMore::MSA::ConformitesCotisationsController < APIEntreprise::V3AndMore::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::MSA::ConformitesCotisationsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::MSA::ConformitesCotisations)
  end
end
