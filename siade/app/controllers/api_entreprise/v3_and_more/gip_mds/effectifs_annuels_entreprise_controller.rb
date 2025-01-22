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
      year: params[:year]
    }
  end

  def serializer_module
    ::APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::GIPMDS::EffectifsAnnuelsEntreprise)
  end
end
