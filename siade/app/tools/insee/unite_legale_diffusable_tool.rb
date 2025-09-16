class INSEE::UniteLegaleDiffusableTool < MCP::Tool
  tool_name 'insee_unite_legale_diffusable'
  description "Permet d'obtenir les informations issue du répertoire SIRENE de l'INSEE d'une unité légale à partir de son SIREN"

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.call(siren:)
    organizer = INSEE::UniteLegaleDiffusable.call(
      params: { siren: },
      operation_id: 'insee_unite_legale_diffusable_tool'
    )

    if organizer.success?
      MCP::Tool::Response.new([{ type: 'text', text: organizer.bundled_data.data.to_json }])
    else
      MCP::Tool::Response.new([{ type: 'text', text: 'Ce numéro de siren ne semble pas existé' }])
    end
  end
end
