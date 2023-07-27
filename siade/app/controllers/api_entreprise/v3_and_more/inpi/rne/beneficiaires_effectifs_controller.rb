class APIEntreprise::V3AndMore::INPI::RNE::BeneficiairesEffectifsController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::INPI::RNE::BeneficiairesEffectifs, cache: true, expires_in:)

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
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::INPI::RNE::BeneficiairesEffectifsSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day + 3.hours - Time.zone.now).to_i
  end
end
