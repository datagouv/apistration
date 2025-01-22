class APIEntreprise::V3AndMore::BanqueDeFrance::BilansEntrepriseController < APIEntreprise::V3AndMore::BaseController
  include APIEntreprise::CommonDGFIPOrganizerParams

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
    common_dgfip_organizer_params.merge(
      siren: params.require(:siren)
    )
  end

  def serializer_module
    ::APIEntreprise::BanqueDeFrance::BilansEntrepriseSerializer
  end

  def expires_in
    (Time.zone.now.end_of_day - Time.zone.now).to_i
  end

  def organizer
    @organizer ||= retrieve_payload_data(::BanqueDeFrance::BilansEntreprise, cache: true, expires_in:)
  end
end
