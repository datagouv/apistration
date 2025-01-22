class APIEntreprise::V3AndMore::INPI::RNE::ActesBilansController < APIEntreprise::V3AndMore::BaseController
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
      token_id: current_user.token_id
    }
  end

  def serializer_module
    ::APIEntreprise::INPI::RNE::ActesBilansSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INPI::RNE::ActesBilans)
  end
end
