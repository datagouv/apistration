RSpec.describe ApiGouvCommons::Error do
  it 'exposes http_status, method, url, and errors' do
    err = described_class.new(
      nil,
      http_status: 422,
      errors: [{ 'code' => '00201', 'title' => 'Entité non traitable', 'detail' => 'Missing context' }],
      method: :get,
      url: 'https://x.test/foo'
    )
    expect(err.http_status).to eq(422)
    expect(err.method).to eq(:get)
    expect(err.url).to eq('https://x.test/foo')
    expect(err.first_error_code).to eq('00201')
    expect(err.first_error_detail).to eq('Missing context')
  end

  it 'builds a default message from http status + title/detail' do
    err = described_class.new(
      nil,
      http_status: 404,
      errors: [{ 'title' => 'Not found', 'detail' => 'Gone' }]
    )
    expect(err.message).to include('404', 'Not found', 'Gone')
  end

  it 'handles no errors array gracefully' do
    err = described_class.new(nil, http_status: 500)
    expect(err.first_error_code).to be_nil
    expect(err.first_error_meta).to eq({})
  end

  it 'exposes retry_after on RateLimitError and ProviderError' do
    rl = ApiGouvCommons::RateLimitError.new(nil, http_status: 429, retry_after: 12)
    expect(rl.retry_after).to eq(12)
    pr = ApiGouvCommons::ProviderError.new(nil, http_status: 502, retry_after: 300)
    expect(pr.retry_after).to eq(300)
  end
end
