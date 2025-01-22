class APIEntreprise::V3AndMore::INPI::RNE::BeneficiairesEffectifsController < APIEntreprise::V3AndMore::BaseController
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
    ::APIEntreprise::INPI::RNE::BeneficiairesEffectifsSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day + 3.hours - Time.zone.now).to_i
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INPI::RNE::BeneficiairesEffectifs, cache: true, expires_in:)
  end
end
