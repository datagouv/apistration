class APIEntreprise::V3AndMore::DGFIP::AttestationsFiscalesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::DGFIP::AttestationFiscale, cache: true, expires_in:)

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
      user_id: current_user.id
    }
  end

  def serializer_module
    ::APIEntreprise::DGFIP::AttestationFiscaleSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day + 8.hours - Time.zone.now).to_i
  end
end
