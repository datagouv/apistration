RSpec.describe INSEE::UniteLegaleTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: INSEE::UniteLegale,
    tool_params: {
      siren: valid_siren
    },
    retriever_params: {
      siren: valid_siren
    }
end
