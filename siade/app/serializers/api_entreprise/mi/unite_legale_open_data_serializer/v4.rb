class APIEntreprise::MI::UniteLegaleOpenDataSerializer::V4 < APIEntreprise::MI::UniteLegaleSerializer::SharedV4
  attribute :etablissements do |object|
    object.etablissements.map do |etablissement|
      etablissement.except(
        :representants_legaux,
        :documents_dac
      )
    end
  end
end
