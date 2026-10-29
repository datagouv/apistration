class APIEntreprise::V3AndMore::MI::UnitesLegalesController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 4 => ::DJEPVA::UniteLegale }

  private

  def organizer_params
    {
      id: params.require(:siren_or_rna)
    }
  end

  def serializer_module
    ::APIEntreprise::MI::UniteLegaleSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DJEPVA::UniteLegale, cache: true, expires_in: 1.hour)
  end
end
