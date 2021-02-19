class API::V3::RNM::EntreprisesArtisanalesController < API::AuthenticateEntityController
  def show
    authorize :entreprise_artisanale

    organizer = ::RNM::EntreprisesArtisanales.call(params: organizer_params)

    if organizer.success?
      render json: ::RNM::EntrepriseArtisanaleSerializer.new(organizer.resource).serializable_hash,
             status: organizer.status
    else
      # NOTE: NOT YET TESTED
      # render json: ErrorsSerializer.new(organizer.errors).serializable_hash,
      #        status: organizer.status
      render json: {
        errors: [
          {
            status: '404',
            title: 'Entitée non trouvée'
          }
        ]
      }, status: 404
    end
  end

  private

  def organizer_params
    {
      siren: params.require(:siren),
    }
  end
end
