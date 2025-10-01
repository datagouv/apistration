RSpec.describe DGFIP::AttestationFiscaleTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: DGFIP::AttestationFiscale,
    tool_params: {
      siren: valid_siren,
      server_context: {
        request_id: 'some-unique-request-id',
        user_id: 42
      }
    },
    retriever_params: {
      siren: valid_siren,
      request_id: 'some-unique-request-id',
      user_id: 42
    }
end
