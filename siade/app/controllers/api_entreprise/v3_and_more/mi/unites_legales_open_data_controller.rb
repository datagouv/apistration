class APIEntreprise::V3AndMore::MI::UnitesLegalesOpenDataController < APIEntreprise::V3AndMore::MI::UnitesLegalesController
  private

  def serializer_module
    ::APIEntreprise::MI::UniteLegaleOpenDataSerializer
  end
end
