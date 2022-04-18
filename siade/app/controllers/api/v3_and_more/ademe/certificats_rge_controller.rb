class API::V3AndMore::ADEME::CertificatsRGEController < API::V3AndMore::BaseController
  def show
    authorize :certificat_rge_ademe

    organizer = ::ADEME::CertificatsRGE.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource, options(organizer)).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret),
      size: 10_000
    }
  end

  def options(organizer)
    {
      meta: organizer.meta
    }
  end

  def serializer_module
    ::ADEME::CertificatsRGESerializer
  end
end
