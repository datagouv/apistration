class APIEntreprise::V3AndMore::DGDDI::EORIController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::DGDDI::EORI)

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
      siret_or_eori: params.require(:siret_or_eori)
    }
  end

  def serializer_module
    ::APIEntreprise::DGDDI::EORISerializer
  end
end
