RSpec.describe QUALIBAT::CertificationsBatimentTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: QUALIBAT::CertificationsBatiment,
    tool_params: {
      siret: valid_siret
    },
    retriever_params: {
      siret: valid_siret,
      api_version: '4'
    }
end
