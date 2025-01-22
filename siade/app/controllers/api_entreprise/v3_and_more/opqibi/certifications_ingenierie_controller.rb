class APIEntreprise::V3AndMore::OPQIBI::CertificationsIngenierieController < APIEntreprise::V3AndMore::BaseController
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
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::OPQIBI::CertificationsIngenierieSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::OPQIBI::CertificationsIngenierie)
  end
end
