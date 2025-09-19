RSpec.describe URSSAF::AttestationsSocialesTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: URSSAF::AttestationsSociales,
    tool_params: {
      siren: valid_siren
    },
    retriever_params: {
      siren: valid_siren,
      user_id: '1',
      recipient: '13002526500013'
    }
end
