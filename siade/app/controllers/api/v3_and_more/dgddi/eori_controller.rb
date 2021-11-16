class API::V3AndMore::DGDDI::EORIController < API::V3AndMore::BaseController
  def show
    authorize :eori_douanes

    organizer = ::DGDDI::EORI.call(params: organizer_params)

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
      siret_or_eori: params.require(:siret_or_eori)
    }
  end

  def serializer_module
    ::DGDDI::EORISerializer
  end
end
