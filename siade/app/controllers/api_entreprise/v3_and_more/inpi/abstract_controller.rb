class APIEntreprise::V3AndMore::INPI::AbstractController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(organizer_klass)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def organizer_klass
    raise ::NotImplementedError
  end

  def organizer_params
    {
      siren: params.require(:siren),
      limit: 5
    }
  end
end
