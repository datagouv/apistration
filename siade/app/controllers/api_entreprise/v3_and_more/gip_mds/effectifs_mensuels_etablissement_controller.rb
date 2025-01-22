class APIEntreprise::V3AndMore::GIPMDS::EffectifsMensuelsEtablissementController < APIEntreprise::V3AndMore::BaseController
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
      siret: params[:siret],
      year: params[:year],
      month: params[:month],
      depth: params[:profondeur]
    }
  end

  def serializer_module
    ::APIEntreprise::GIPMDS::EffectifsMensuelsEtablissementSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::GIPMDS::EffectifsMensuelsEtablissement)
  end
end
