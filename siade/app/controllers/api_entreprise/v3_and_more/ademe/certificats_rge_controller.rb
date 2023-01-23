class APIEntreprise::V3AndMore::ADEME::CertificatsRGEController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::ADEME::CertificatsRGE)

    if organizer.success?
      render json: serialize_data(organizer),
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
