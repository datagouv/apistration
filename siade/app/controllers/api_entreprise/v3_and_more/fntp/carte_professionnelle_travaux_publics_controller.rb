class APIEntreprise::V3AndMore::FNTP::CarteProfessionnelleTravauxPublicsController < APIEntreprise::V3AndMore::BaseController
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
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::FNTP::CarteProfessionnelleTravauxPublicsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::FNTP::CarteProfessionnelleTravauxPublics)
  end
end
