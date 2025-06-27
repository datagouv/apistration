class APIEntreprise::V3AndMore::INPI::RNE::ExtraitRNEController < APIEntreprise::V3AndMore::BaseController
  include APIEntreprise::INPIRNECache

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
    ::APIEntreprise::INPI::RNE::ExtraitRNESerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INPI::RNE::ExtraitRNE, cache: true, expires_in:)
  end
end
