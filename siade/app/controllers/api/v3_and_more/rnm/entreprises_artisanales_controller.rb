class API::V3AndMore::RNM::EntreprisesArtisanalesController < API::V3AndMore::BaseController
  def show
    authorize :entreprises_artisanales

    organizer = ::RNM::EntreprisesArtisanales.call(params: organizer_params)

    if organizer.success?
      render json:   serializer_class.new(organizer.bundled_data).serializable_hash,
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
    ::RNM::EntrepriseArtisanaleSerializer
  end
end
