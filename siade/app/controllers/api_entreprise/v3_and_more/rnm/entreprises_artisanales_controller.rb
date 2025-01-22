class APIEntreprise::V3AndMore::RNM::EntreprisesArtisanalesController < APIEntreprise::V3AndMore::BaseController
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
    ::APIEntreprise::RNM::EntrepriseArtisanaleSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::RNM::EntreprisesArtisanales)
  end
end
