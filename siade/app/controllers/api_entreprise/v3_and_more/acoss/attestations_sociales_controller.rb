class APIEntreprise::V3AndMore::ACOSS::AttestationsSocialesController < APIEntreprise::V3AndMore::BaseController
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
      siren: params.require(:siren),
      user_id: current_user.logstash_id
    }
  end

  def retrieve_organizer_based_on_version
    if api_version == 3
      ::ACOSS::AttestationsSociales
    else
      ::URSSAF::AttestationsSociales
    end
  end

  def serializer_module
    ::APIEntreprise::ACOSS::AttestationSocialeSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day + 8.hours - Time.zone.now).to_i
  end

  def organizer
    @organizer ||= retrieve_payload_data(retrieve_organizer_based_on_version, cache: true, expires_in:)
  end
end
