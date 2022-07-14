class API::V3AndMore::QUALIBAT::CertificationsBatimentController < API::V3AndMore::BaseController
  def show
    authorize :qualibat

    organizer = ::QUALIBAT::CertificationsBatiment.call(params: organizer_params)

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
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::QUALIBAT::CertificationBatimentSerializer
  end
end
