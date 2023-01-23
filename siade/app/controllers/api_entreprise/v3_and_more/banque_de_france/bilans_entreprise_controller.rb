class APIEntreprise::V3AndMore::BanqueDeFrance::BilansEntrepriseController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::BanqueDeFrance::BilansEntreprise)

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
    ::APIEntreprise::BanqueDeFrance::BilansEntrepriseSerializer
  end
end
