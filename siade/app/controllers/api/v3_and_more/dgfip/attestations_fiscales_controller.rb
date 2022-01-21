class API::V3AndMore::DGFIP::AttestationsFiscalesController < API::V3AndMore::BaseController
  def show
    authorize :attestations_fiscales

    organizer = ::DGFIP::AttestationFiscale.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siren: params[:siren],
      user_id: @authenticated_user.id
    }
  end

  def serializer_module
    ::DGFIP::AttestationFiscaleSerializer
  end
end
