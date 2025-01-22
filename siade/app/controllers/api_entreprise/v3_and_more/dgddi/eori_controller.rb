class APIEntreprise::V3AndMore::DGDDI::EORIController < APIEntreprise::V3AndMore::BaseController
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
      siret_or_eori: params.require(:siret_or_eori)
    }
  end

  def serializer_module
    ::APIEntreprise::DGDDI::EORISerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DGDDI::EORI)
  end
end
