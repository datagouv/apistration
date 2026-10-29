class APIEntreprise::V3AndMore::INSEE::SiegesDiffusablesUnitesLegalesController < APIEntreprise::V3AndMore::INSEE::BaseController
  nomenclature organizers: { 3 => ::INSEE::SiegeDiffusableUniteLegale, 4 => ::INSEE::SiegeDiffusableUniteLegale }

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
    @organizer ||= retrieve_payload_data(::INSEE::SiegeDiffusableUniteLegale)
  end
end
