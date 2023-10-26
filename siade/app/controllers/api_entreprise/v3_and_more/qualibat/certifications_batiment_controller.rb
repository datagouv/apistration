class APIEntreprise::V3AndMore::QUALIBAT::CertificationsBatimentController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::QUALIBAT::CertificationsBatiment, cache: true, expires_in:)

    if organizer.success?
      render json:   serialize_data(organizer),
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
    ::APIEntreprise::QUALIBAT::CertificationBatimentSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day - Time.zone.now).to_i
  end
end
