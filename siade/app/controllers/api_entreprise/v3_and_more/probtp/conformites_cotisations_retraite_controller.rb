class APIEntreprise::V3AndMore::PROBTP::ConformitesCotisationsRetraiteController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::PROBTP::ConformitesCotisationsRetraite }

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::PROBTP::ConformitesCotisationsRetraiteSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::PROBTP::ConformitesCotisationsRetraite)
  end
end
