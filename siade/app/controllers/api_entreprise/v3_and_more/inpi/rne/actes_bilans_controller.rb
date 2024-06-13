class APIEntreprise::V3AndMore::INPI::RNE::ActesBilansController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::INPI::RNE::ActesBilans)

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
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::INPI::RNE::ActesBilansSerializer
  end
end
