class APIEntreprise::V3AndMore::INSEE::SuccessionsController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::INSEE::Successions)

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
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::SuccessionsSerializer
  end
end
