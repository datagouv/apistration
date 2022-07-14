class API::V3AndMore::PROBTP::ConformitesCotisationsRetraiteController < API::V3AndMore::BaseController
  def show
    authorize :probtp

    organizer = ::PROBTP::ConformitesCotisationsRetraite.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::PROBTP::ConformitesCotisationsRetraiteSerializer
  end
end
