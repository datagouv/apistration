RSpec.describe DataPassAPIClient do
  let(:data_pass_api_authentication) { instance_double(DataPassAPIAuthentication, access_token: 'access_token') }

  before do
    allow(DataPassAPIAuthentication).to receive(:new).and_return(data_pass_api_authentication)
  end

  describe '#definitions' do
    subject(:definitions) { described_class.new.definitions('api_entreprise') }

    let(:url) { "#{DataPass::BASE_URL}/api/v1/definitions/api_entreprise" }

    context 'when the API returns a 200' do
      let(:payload) do
        {
          'id' => 'api_entreprise',
          'name' => 'API Entreprise',
          'scopes' => [
            { 'name' => 'Data', 'value' => 'a_scope', 'group' => 'Group', 'provider' => 'INSEE', 'link' => nil }
          ]
        }
      end

      before do
        stub_request(:get, url)
          .with(headers: { 'Authorization' => 'Bearer access_token' })
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: payload.to_json
          )
      end

      it 'returns the parsed definition payload' do
        expect(definitions).to eq(payload)
      end
    end

    context 'when the API returns an error status' do
      before do
        stub_request(:get, url).to_return(status: 500)
      end

      it 'raises a Faraday error' do
        expect { definitions }.to raise_error(Faraday::Error)
      end
    end
  end
end
