class APIEntreprise::V3AndMore::ADEME::CertificatsRGEController < APIEntreprise::V3AndMore::BaseController
  def show
    authorize :certificat_rge_ademe

    organizer = ::ADEME::CertificatsRGE.call(params: organizer_params)

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
      siret: params.require(:siret),
      limit: params[:limit]
    }
  end

  def serializer_module
    ::APIEntreprise::ADEME::CertificatRGESerializer
  end
end
