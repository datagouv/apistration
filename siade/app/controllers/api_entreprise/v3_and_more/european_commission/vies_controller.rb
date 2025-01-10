class APIEntreprise::V3AndMore::EuropeanCommission::VIESController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::EuropeanCommission::VIES, cache: true, expires_in: 24.hours)

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
      siren: params[:siren]
    }
  end

  def serializer_module
    ::APIEntreprise::EuropeanCommission::VIESSerializer
  end
end
