RSpec.describe INSEE::EtablissementTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: INSEE::Etablissement,
    tool_params: {
      siret: valid_siret
    },
    retriever_params: {
      siret: valid_siret
    }
end
