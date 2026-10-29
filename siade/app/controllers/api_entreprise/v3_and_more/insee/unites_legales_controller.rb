class APIEntreprise::V3AndMore::INSEE::UnitesLegalesController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::UniteLegale, 4 => ::INSEE::UniteLegale }

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
    @organizer ||= retrieve_payload_data(::INSEE::UniteLegale)
  end
end
