class APIEntreprise::V3AndMore::BanqueDeFrance::BilansEntrepriseController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::BanqueDeFrance::BilansEntreprise)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data).serializable_hash,
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

  def options(organizer)
    {
      meta: organizer.meta
    }
  end

  def serializer_module
    ::APIEntreprise::BanqueDeFrance::BilansEntrepriseSerializer
  end
end
