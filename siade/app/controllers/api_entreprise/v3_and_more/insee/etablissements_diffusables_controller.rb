class APIEntreprise::V3AndMore::INSEE::EtablissementsDiffusablesController < APIEntreprise::V3AndMore::INSEE::BaseController
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
    ::APIEntreprise::INSEE::EtablissementSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INSEE::EtablissementDiffusable)
  end
end
