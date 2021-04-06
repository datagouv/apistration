class API::V3::PROBTP::AttestationsCotisationRetraiteController < API::AuthenticateEntityController
  def show
    authorize :probtp

    organizer = ::PROBTP::AttestationsCotisationsRetraite.call(params: organizer_params)

    if organizer.success?
      render json: ::PROBTP::AttestationCotisationRetraiteSerializer.new(organizer.resource).serializable_hash,
             status: organizer.status
    else
      # FIXME title: organizer.errors.first
      # kinda ugly, it's to be compliant with RSwag 404 component
      # It's gonna be refactor later with errors management
      render json: {
        errors: [
          {
            status: organizer.status.to_s,
            title: organizer.errors.first,
          }
        ],
      },
      status: organizer.status
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret),
    }
  end
end
