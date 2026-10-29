class APIEntreprise::V3AndMore::MSA::ConformitesCotisationsController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::MSA::ConformitesCotisations }

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::MSA::ConformitesCotisationsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::MSA::ConformitesCotisations)
  end
end
