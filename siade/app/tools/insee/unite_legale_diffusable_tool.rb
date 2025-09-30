class INSEE::UniteLegaleDiffusableTool < ApplicationTool
  title 'INSEE - Unités légales diffusables'
  tool_name 'insee/unite_legale_diffusable'
  description "Permet d'obtenir les informations diffusables issue du répertoire SIRENE de l'INSEE d'une unité légale à partir de son SIREN. Les données diffusables sont celles qui peuvent être librement partagées et utilisées, conformément aux règles de confidentialité et de protection des données."

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
