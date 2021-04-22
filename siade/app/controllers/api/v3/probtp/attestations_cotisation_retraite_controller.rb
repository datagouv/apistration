class API::V3::PROBTP::AttestationsCotisationRetraiteController < API::V3::BaseController
  def show
    authorize :probtp

    organizer = ::PROBTP::AttestationsCotisationsRetraite.call(params: organizer_params)

    if organizer.success?
      render json: ::PROBTP::AttestationCotisationRetraiteSerializer.new(organizer.resource).serializable_hash,
             status: organizer.status
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret),
    }
  end
end
