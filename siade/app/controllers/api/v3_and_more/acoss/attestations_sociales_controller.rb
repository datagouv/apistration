class API::V3AndMore::ACOSS::AttestationsSocialesController < API::V3AndMore::BaseController
  def show
    authorize :attestations_sociales

    organizer = ::ACOSS::AttestationsSociales.call(params: organizer_params)

    if organizer.success?
      render json:   ::ACOSS::AttestationSocialeSerializer::V3.new(organizer.bundled_data).serializable_hash,
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
    ::ACOSS::AttestationSocialeSerializer
  end
end
