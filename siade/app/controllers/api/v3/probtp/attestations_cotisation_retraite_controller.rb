class API::V3::PROBTP::AttestationsCotisationRetraiteController < API::AuthenticateEntityController
  def show
    authorize :probtp

    organizer = ::PROBTP::AttestationsCotisationsRetraite.call(params: organizer_params)

    if organizer.success?
      render json: ::PROBTP::AttestationCotisationRetraiteSerializer.new(organizer.resource).serializable_hash,
             status: organizer.status
    else
      render json: { errors: organizer.errors }, status: organizer.status
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret),
    }
  end
end
