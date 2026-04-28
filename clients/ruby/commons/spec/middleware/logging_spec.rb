RSpec.describe 'Logging middleware' do
  let(:logger) do
    Class.new do
      attr_reader :info_calls, :error_calls

      def initialize
        @info_calls = []
        @error_calls = []
      end

      def info(payload)
        @info_calls << payload
      end

      def error(payload)
        @error_calls << payload
      end
    end.new
  end

  it 'logs method/url/status/duration/rate_limit_remaining on success' do
    client = TestClientSupport.build_client(logger: logger)
    stub_request(:get, 'https://example.test/v3/foo')
      .with(query: hash_including('recipient' => '13002526500013'))
      .to_return(status: 200,
                 headers: { 'Content-Type' => 'application/json', 'RateLimit-Remaining' => '48' },
                 body: { data: {}, links: {}, meta: {} }.to_json)
    client.get('/v3/foo')
    expect(logger.info_calls.last).to include(
      method: 'GET',
      status: 200,
      rate_limit_remaining: 48
    )
    expect(logger.info_calls.last[:duration_ms]).to be >= 0
  end

  it 'redacts the query string for the particulier product' do
    cfg = ApiGouvCommons::Configuration.new(
      base_urls: TestClientSupport::BASE_URLS,
      token: 't',
      default_params: { recipient: '13002526500013' },
      logger: logger
    )
    client = ApiGouvCommons::ClientBase.new(cfg, product: :particulier)
    client.singleton_class.send(:define_method, :required_params_for) { |_| [:recipient] }

    stub_request(:get, /https:\/\/example\.test\/v3\/bar/)
      .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                 body: { data: {}, links: {}, meta: {} }.to_json)

    client.get('/v3/bar', params: { nomNaissance: 'DUPONT' })
    expect(logger.info_calls.last[:url]).to include('[REDACTED]')
    expect(logger.info_calls.last[:url]).not_to include('DUPONT')
  end
end
