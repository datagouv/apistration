class APIEntreprise::V3AndMore::EuropeanCommission::VIESController < APIEntreprise::V3AndMore::BaseController
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
      siren: params[:siren]
    }
  end

  def serializer_module
    ::APIEntreprise::EuropeanCommission::VIESSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::EuropeanCommission::VIES, cache: true, expires_in: 24.hours)
  end
end
