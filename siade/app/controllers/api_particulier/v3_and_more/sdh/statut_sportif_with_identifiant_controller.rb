class APIParticulier::V3AndMore::SDH::StatutSportifWithIdentifiantController < APIParticulier::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::SDH::StatutSportif }

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
      identifiant: params[:identifiant]
    }
  end

  def serializer_module
    ::APIParticulier::SDH::StatutSportifSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::SDH::StatutSportif)
  end
end
