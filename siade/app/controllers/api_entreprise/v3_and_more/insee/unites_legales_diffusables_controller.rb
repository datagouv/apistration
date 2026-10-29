class APIEntreprise::V3AndMore::INSEE::UnitesLegalesDiffusablesController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::UniteLegaleDiffusable, 4 => ::INSEE::UniteLegaleDiffusable }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::UniteLegaleSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INSEE::UniteLegaleDiffusable)
  end
end
