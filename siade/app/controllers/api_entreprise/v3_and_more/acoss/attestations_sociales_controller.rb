class APIEntreprise::V3AndMore::ACOSS::AttestationsSocialesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::ACOSS::AttestationsSociales, cache: true, expires_in:, cache_key:)

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
      siren: params.require(:siren),
      user_id: current_user.logstash_id,
      recipient: params[:recipient]
    }
  end

  def serializer_module
    ::APIEntreprise::ACOSS::AttestationSocialeSerializer
  end

  def cache_key
    "acoss/attestations_sociales:siren=#{params[:siren]}"
  end

  def expires_in
    (Time.zone.now.end_of_day + 8.hours - Time.zone.now).to_i
  end
end
