RSpec.describe Infogreffe::MandatairesSociauxTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: Infogreffe::MandatairesSociaux,
    tool_params: {
      siren: valid_siren
    },
    retriever_params: {
      siren: valid_siren
    }
end
