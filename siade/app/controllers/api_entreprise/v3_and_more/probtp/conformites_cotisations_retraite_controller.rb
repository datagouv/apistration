class APIEntreprise::V3AndMore::PROBTP::ConformitesCotisationsRetraiteController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::PROBTP::ConformitesCotisationsRetraite)

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
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::PROBTP::ConformitesCotisationsRetraiteSerializer
  end
end
