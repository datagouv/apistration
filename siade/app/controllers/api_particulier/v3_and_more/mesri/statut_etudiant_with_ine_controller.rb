class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithINEController < APIParticulier::V3AndMore::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      ine: params[:ine],
      token_id: current_user.token_id
    }
  end

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(MESRI::StudentStatus::WithINE)
  end
end
