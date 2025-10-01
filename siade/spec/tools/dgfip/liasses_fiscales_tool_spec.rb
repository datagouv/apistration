RSpec.describe DGFIP::LiassesFiscalesTool, type: :tool do
  it_behaves_like 'valid MCP tool',
    retriever: DGFIP::LiassesFiscales,
    tool_params: {
      siren: valid_siren,
      year: '2022',
      server_context: {
        request_id: 'some-unique-request-id',
        user_id: 42
      }
    },
    retriever_params: {
      siren: valid_siren,
      year: '2022',
      request_id: 'some-unique-request-id',
      user_id: 42
    }
end
