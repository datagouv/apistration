RSpec.describe ApiGouvCommons::ClientBase do
  let(:client) { TestClientSupport.build_client }

  def stub_ok(path, headers: {}, body: nil)
    stub_request(:get, "https://example.test#{path}")
      .with(query: hash_including({}))
      .to_return(
        status: 200,
        headers: { 'Content-Type' => 'application/json' }.merge(headers),
        body: body || {
          data: { 'siren' => '418166096' },
          links: {},
          meta: { 'provider' => 'INSEE' }
        }.to_json
      )
  end

  describe 'happy path' do
    it 'returns a Response with data/links/meta and rate-limit parsed' do
      stub_ok('/v3/foo',
              headers: {
                'RateLimit-Limit' => '50',
                'RateLimit-Remaining' => '49',
                'RateLimit-Reset' => '1700000000'
              })
      response = client.get('/v3/foo')
      expect(response.success?).to be true
      expect(response.data).to eq('siren' => '418166096')
      expect(response.meta).to eq('provider' => 'INSEE')
      expect(response.rate_limit.remaining).to eq(49)
      expect(response.rate_limit.limit).to eq(50)
    end

    it 'sends the Bearer token' do
      stub = stub_ok('/v3/foo').with(headers: { 'Authorization' => 'Bearer test-token' })
      client.get('/v3/foo')
      expect(stub).to have_been_requested
    end

    it 'merges default_params with per-call params and drops nil' do
      stub = stub_request(:get, 'https://example.test/v3/foo')
             .with(query: hash_including('recipient' => '13002526500013', 'context' => 'override', 'object' => 'obj'))
             .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                        body: { data: {}, links: {}, meta: {} }.to_json)
      client.get('/v3/foo', params: { context: 'override', extra: nil })
      expect(stub).to have_been_requested
    end
  end

  describe 'local validation (before any HTTP call)' do
    it 'raises MissingParameterError if a required param is missing' do
      barebone = TestClientSupport.build_client(default_params: { recipient: '13002526500013' })
      expect { barebone.get('/v3/foo') }
        .to raise_error(ApiGouvCommons::MissingParameterError, /context/)
      expect(a_request(:get, /.+/)).not_to have_been_made
    end

    it 'raises InvalidSiretError on a malformed recipient' do
      expect { client.get('/v3/foo', params: { recipient: 'nope' }) }
        .to raise_error(ApiGouvCommons::InvalidSiretError)
      expect(a_request(:get, /.+/)).not_to have_been_made
    end

    it 'raises AuthenticationError without an HTTP call when auth strategy raises' do
      strategy = Class.new(ApiGouvCommons::Auth::Strategy) do
        def apply(_req)
          raise 'boom'
        end
      end.new
      cfg = ApiGouvCommons::Configuration.new(
        base_urls: TestClientSupport::BASE_URLS,
        auth_strategy: strategy,
        default_params: { recipient: '13002526500013', context: 'c', object: 'o' }
      )
      faulty = ApiGouvCommons::ClientBase.new(cfg, product: :entreprise)
      expect { faulty.get('/v3/foo') }
        .to raise_error(ApiGouvCommons::AuthenticationError, /boom/)
      expect(a_request(:get, /.+/)).not_to have_been_made
    end
  end
end
