class APIEntreprise::V3AndMore::QUALIBAT::CertificationsBatimentController < APIEntreprise::V3AndMore::BaseController
  def show
    if organizer.success?
      render json:   serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret),
      api_version: params.require(:api_version)
    }
  end

  def serializer_module
    ::APIEntreprise::QUALIBAT::CertificationBatimentSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day - Time.zone.now).to_i
  end

  def organizer
    @organizer ||= retrieve_payload_data(::QUALIBAT::CertificationsBatiment, cache: true, expires_in:)
  end
end
