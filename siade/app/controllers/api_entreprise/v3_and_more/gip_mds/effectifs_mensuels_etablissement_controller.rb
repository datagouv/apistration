class APIEntreprise::V3AndMore::GIPMDS::EffectifsMensuelsEtablissementController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::GIPMDS::EffectifsMensuelsEtablissement)

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
      siret: params[:siret],
      year: params[:year],
      month: params[:month],
      depth: params[:profondeur]
    }
  end

  def serializer_module
    ::APIEntreprise::GIPMDS::EffectifsMensuelsEtablissementSerializer
  end
end
