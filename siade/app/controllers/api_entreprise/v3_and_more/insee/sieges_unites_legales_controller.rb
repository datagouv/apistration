class APIEntreprise::V3AndMore::INSEE::SiegesUnitesLegalesController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::SiegeUniteLegale, 4 => ::INSEE::SiegeUniteLegale }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::INSEE::EtablissementSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::INSEE::SiegeUniteLegale)
  end
end
