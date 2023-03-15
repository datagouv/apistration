class APIEntreprise::V3AndMore::GIPMDS::EffectifsAnnuelsEntrepriseController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::GIPMDS::EffectifsAnnuelsEntreprise)

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
      siren: params[:siren],
      year: params[:year]
    }
  end

  def serializer_module
    ::APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer
  end
end
