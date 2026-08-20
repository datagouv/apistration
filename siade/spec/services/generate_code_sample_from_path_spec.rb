RSpec.describe GenerateCodeSampleFromPath, type: :service do
  subject(:curl_example) { described_class.new(path).perform }

  let(:path) { '/v3/insee/sirene/unites_legales/{siren}' }

  it 'adds valid header params' do
    expect(curl_example).to include('-H "Authorization: Bearer $token"')
  end

  it 'adds valid query params' do
    expect(curl_example).to include('recipient=10000001700010')
    expect(curl_example).to include('object=Test+de')
  end

  it 'interpolates parameters with valid value' do
    expect(curl_example).to include('/v3/insee/sirene/unites_legales/130025265')
  end

  it 'targets production by default' do
    expect(curl_example).to include('https://entreprise.api.gouv.fr/v3')
  end

  context 'when the endpoint is staging only' do
    subject(:curl_example) { described_class.new(path, staging: true).perform }

    it 'targets the staging host' do
      expect(curl_example).to include('https://staging.entreprise.api.gouv.fr/v3')
    end
  end
end
