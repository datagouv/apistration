RSpec.describe DGFIP::ChiffresAffairesTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: DGFIP::ChiffresAffaires,
    tool_params: {
      siret: valid_siret,
      server_context: {
        request_id: 'some-unique-request-id',
        user_id: 42
      }
    },
    retriever_params: {
      siret: valid_siret,
      request_id: 'some-unique-request-id',
      user_id: 42
    }
end
