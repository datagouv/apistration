class APIEntreprise::V3AndMore::GIPMDS::EffectifsAnnuelsEntrepriseController < APIEntreprise::V3AndMore::BaseController
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
      siren: params[:siren],
      year: params[:year],
      nature_effectif: params[:nature_effectif]
    }
  end

  def serializer_module
    ::APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day - Time.zone.now).to_i
  end

  def cache_key
    [request.path, params[:nature_effectif]].compact.join('/')
  end

  def organizer
    @organizer ||= retrieve_payload_data(::GIPMDS::EffectifsAnnuelsEntreprise, cache: true, expires_in:)
  end
end
