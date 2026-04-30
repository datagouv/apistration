RSpec.describe 'Envelope middleware' do
  let(:client) { TestClientSupport.build_client }

  it 'parses JSON body into a Hash' do
    stub_request(:get, 'https://example.test/v3/foo')
      .with(query: hash_including('recipient' => '13002526500013'))
      .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                 body: '{"data":{"a":1},"links":{},"meta":{}}')
    expect(client.get('/v3/foo').data).to eq('a' => 1)
  end

  it 'raises TransportError on non-JSON body' do
    stub_request(:get, 'https://example.test/v3/foo')
      .with(query: hash_including('recipient' => '13002526500013'))
      .to_return(status: 200, headers: { 'Content-Type' => 'application/json' }, body: 'not-json')
    expect { client.get('/v3/foo') }.to raise_error(ApiGouvCommons::TransportError, /invalid JSON/)
  end
end
