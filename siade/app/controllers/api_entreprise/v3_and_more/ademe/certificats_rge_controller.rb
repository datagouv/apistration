class APIEntreprise::V3AndMore::ADEME::CertificatsRGEController < APIEntreprise::V3AndMore::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors
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

  def organizer
    @organizer ||= retrieve_payload_data(::ADEME::CertificatsRGE)
  end
end
