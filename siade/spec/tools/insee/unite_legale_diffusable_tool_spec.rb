RSpec.describe INSEE::UniteLegaleDiffusableTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: INSEE::UniteLegaleDiffusable,
    tool_params: {
      siren: valid_siren
    },
    retriever_params: {
      siren: valid_siren
    }
end
