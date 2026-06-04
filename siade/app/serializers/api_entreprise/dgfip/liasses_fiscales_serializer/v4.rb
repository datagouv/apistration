class APIEntreprise::DGFIP::LiassesFiscalesSerializer::V4 < APIEntreprise::DGFIP::LiassesFiscalesSerializer::V3
  REMOVED_DICTIONARY_KEYS = %i[code_absolu code_EDI code code_type_donnee].freeze

  attribute :declarations do
    data.declarations.map do |declaration|
      declaration.merge(
        donnees: declaration[:donnees].map { |donnee| donnee.except(*REMOVED_DICTIONARY_KEYS) }
      )
    end
  end
end
