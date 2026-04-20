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
      depth: params[:profondeur],
      nature_effectif: params[:nature_effectif]
    }
  end

  def serializer_module
    ::APIEntreprise::GIPMDS::EffectifsMensuelsEtablissementSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day - Time.zone.now).to_i
  end

  def cache_key
    [request.path, params[:profondeur], params[:nature_effectif]].compact.join('/')
  end

  def organizer
    @organizer ||= retrieve_payload_data(::GIPMDS::EffectifsMensuelsEtablissement, cache: true, expires_in:)
  end
end
