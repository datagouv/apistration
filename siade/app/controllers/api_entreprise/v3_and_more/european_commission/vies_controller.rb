class APIEntreprise::V3AndMore::EuropeanCommission::VIESController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::EuropeanCommission::VIES }

  private

  def organizer_params
    {
      siren: params[:siren]
    }
  end

  def serializer_module
    ::APIEntreprise::EuropeanCommission::VIESSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::EuropeanCommission::VIES, cache: true, expires_in: 24.hours)
  end
end
