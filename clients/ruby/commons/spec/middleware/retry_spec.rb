RSpec.describe 'Retry middleware' do
  let(:path) { '/v3/foo' }
  let(:url) { "https://example.test#{path}" }

  def build_client(retry_opts)
    cfg = ApiGouvCommons::Configuration.new(
      base_urls: TestClientSupport::BASE_URLS,
      token: 't',
      default_params: { recipient: '13002526500013', context: 'c', object: 'o' },
      retry: retry_opts
    )
    ApiGouvCommons::ClientBase.new(cfg, product: :entreprise)
  end

  it 'retries 502 up to max and returns on success' do
    stub = stub_request(:get, url)
           .with(query: hash_including('recipient' => '13002526500013'))
           .to_return(
             { status: 502, headers: { 'Content-Type' => 'application/json' },
               body: { errors: [{ code: '04001', title: 't', detail: 'd' }] }.to_json },
             { status: 502, headers: { 'Content-Type' => 'application/json' },
               body: { errors: [{ code: '04001', title: 't', detail: 'd' }] }.to_json },
             { status: 200, headers: { 'Content-Type' => 'application/json' },
               body: { data: { ok: true }, links: {}, meta: {} }.to_json }
           )

    client = build_client(max: 3, on_status: [502], interval: 0, backoff_factor: 1)
    response = client.get(path)
    expect(response.http_status).to eq(200)
    expect(stub).to have_been_requested.times(3)
  end

  it 'never retries 404' do
    stub = stub_request(:get, url)
           .with(query: hash_including('recipient' => '13002526500013'))
           .to_return(status: 404, headers: { 'Content-Type' => 'application/json' },
                      body: { errors: [{ code: '00404', title: 't', detail: 'd' }] }.to_json)

    client = build_client(max: 5, on_status: [429, 502, 503], interval: 0)
    expect { client.get(path) }.to raise_error(ApiGouvCommons::NotFoundError)
    expect(stub).to have_been_requested.once
  end

  it 'does not retry when retry config is absent' do
    stub = stub_request(:get, url)
           .with(query: hash_including('recipient' => '13002526500013'))
           .to_return(status: 502, headers: { 'Content-Type' => 'application/json' },
                      body: { errors: [{ code: '04001', title: 't', detail: 'd' }] }.to_json)

    client = TestClientSupport.build_client
    expect { client.get(path) }.to raise_error(ApiGouvCommons::ProviderError)
    expect(stub).to have_been_requested.once
  end
end
