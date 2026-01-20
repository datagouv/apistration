class DGFIP::LiensCapitalistiquesTool < DGFIP::AbstractDGFIPTool
  title 'DGFIP lienscapitalistiques'
  tool_name 'dgfip.liens_capitalistiques'
  description "Actionnaires et filiales de l'entreprise déclarés dans les CERFA 2059F et 2059G des liasses fiscales de la DGFIP.
"

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' },
      year: { type: 'string', pattern: '^\d{4}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    DGFIP::LiensCapitalistiques
  end
end
