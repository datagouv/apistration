class APIEntreprise::V3AndMore::MI::UnitesLegalesOpenDataController < APIEntreprise::V3AndMore::MI::UnitesLegalesController
  nomenclature organizers: { 4 => ::DJEPVA::UniteLegale }

  private

  def serializer_module
    ::APIEntreprise::MI::UniteLegaleOpenDataSerializer
  end
end
