class INSEE::UniteLegaleDiffusableTool < ApplicationTool
  tool_name 'insee_unite_legale_diffusable'
  description "Permet d'obtenir les informations issue du répertoire SIRENE de l'INSEE d'une unité légale à partir de son SIREN"

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    INSEE::UniteLegaleDiffusable
  end
end
