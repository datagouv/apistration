class APIEntreprise::V3AndMore::PROBTP::AttestationsCotisationRetraiteController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::PROBTP::AttestationsCotisationsRetraite)

    if organizer.success?
      render json:   serialize_data(organizer),
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
    ::APIEntreprise::PROBTP::AttestationCotisationRetraiteSerializer
  end
end
