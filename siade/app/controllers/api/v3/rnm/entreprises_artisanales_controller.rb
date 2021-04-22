class API::V3::RNM::EntreprisesArtisanalesController < API::V3::BaseController
  def show
    authorize :entreprise_artisanale

    organizer = ::RNM::EntreprisesArtisanales.call(params: organizer_params)

    if organizer.success?
      render json: ::RNM::EntrepriseArtisanaleSerializer.new(organizer.resource).serializable_hash,
             status: organizer.status
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siren: params.require(:siren),
    }
  end
end
