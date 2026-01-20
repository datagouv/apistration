class INSEE::UniteLegaleTool < ApplicationTool
  title 'INSEE - Unités légales'
  tool_name 'insee.unite_legale'
  description "Permet d'obtenir les informations issue du répertoire SIRENE de l'INSEE d'une unité légale à partir de son SIREN"

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    INSEE::UniteLegale
  end
end
