RSpec.describe Infogreffe::ExtraitsRCSTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: Infogreffe::ExtraitsRCS,
    tool_params: {
      siren: valid_siren
    },
    retriever_params: {
      siren: valid_siren
    }
end
