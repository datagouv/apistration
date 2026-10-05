RSpec.describe DGFIP::Dictionaries, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      year: 2019,
      user_id:,
      request_id:
    }
  end
  let(:request_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  describe 'happy path' do
    let(:dictionnaire_raw) { read_payload_file('dgfip/dictionary.json') }
    let(:dictionnaire) { JSON.parse(dictionnaire_raw)['dictionnaire'] }

    let!(:stubbed_request) do
      mock_dgfip_authenticate

      stub_request(:get, "#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/dictionnaire").with(
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer bearer_token',
          'X-Correlation-ID' => request_id,
          'X-Request-ID' => request_id
        },
        query: {
          'userId' => user_id,
          'annee' => 2019
        }
      ).to_return(
        status: 200,
        body: read_payload_file('dgfip/dictionary.json')
      )
    end

    it { is_expected.to be_a_success }

    it 'calls the stubbed request', :disable_vcr do
      subject

      expect(stubbed_request).to have_been_requested
    end

    it 'bundles the remote dictionnaire completed with the local one' do
      local_numeros_imprimes = JSON.parse(Rails.root.join('config/dgfip/dictionnaires/2019.json').read)['dictionnaire'].pluck('numero_imprime')

      expect(subject.bundled_data.data.dictionnaire.pluck('numero_imprime')).to match_array(local_numeros_imprimes | dictionnaire.pluck('numero_imprime'))
    end
  end
end
