RSpec.describe INPI::RNE::BeneficiairesEffectifsTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: INPI::RNE::BeneficiairesEffectifs,
    tool_params: {
      siren: valid_siren
    },
    retriever_params: {
      siren: valid_siren
    }
end
