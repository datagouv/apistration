RSpec.describe ApiGouvCommons::Response do
  it 'exposes data, links, meta from a well-formed envelope' do
    response = described_class.new(
      raw: { 'data' => { 'siren' => '418166096' }, 'links' => { 'next' => '/n' }, 'meta' => { 'provider' => 'INSEE' } },
      http_status: 200,
      headers: { 'Content-Type' => 'application/json' }
    )
    expect(response.data).to eq('siren' => '418166096')
    expect(response.links).to eq('next' => '/n')
    expect(response.meta).to eq('provider' => 'INSEE')
    expect(response.success?).to be true
  end

  it 'returns empty hashes for missing links/meta' do
    response = described_class.new(raw: { 'data' => {} }, http_status: 200, headers: {})
    expect(response.links).to eq({})
    expect(response.meta).to eq({})
  end

  it 'tolerates non-hash raw by exposing empty envelope' do
    response = described_class.new(raw: nil, http_status: 204, headers: {})
    expect(response.data).to be_nil
    expect(response.links).to eq({})
    expect(response.meta).to eq({})
  end
end
