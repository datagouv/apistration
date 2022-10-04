RSpec.describe DGFIP::LiassesFiscales::EnrichResource, type: :interactor do
  subject(:enricher) { described_class.call(bundled_data:) }

  let(:bundled_data) { builder.bundled_data }
  let(:builder) { DGFIP::LiassesFiscales::BuildResource.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:dictionary_key) { 'dgfip:dictionnaires:year_2017:imprime_2050' }
  let(:dictionary_data) do
    [
      {
        'code' => 'ZZ',
        'code_EDI' => 'XX:X123:2222:2:XXX',
        'code_absolu' => '2345678',
        'code_nref' => '123458',
        'code_type_donnee' => 'XXY',
        'intitule' => 'Déposé néant'
      }
    ]
  end

  before do
    RedisService.instance.set(dictionary_key, dictionary_data)
  end

  describe 'real payload', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:body) { DGFIP::LiassesFiscales::MakeRequest.call(cookie:, params:).response.body }
    let(:cookie) { DGFIP::Authenticate.call.cookie }
    let(:params) do
      {
        siren: valid_siren(:liasse_fiscale),
        user_id: valid_dgfip_user_id,
        year: 2017
      }
    end

    it 'enrich the payload with dictionary data' do
      expect(enricher.bundled_data).to eq({})
    end
  end

  describe 'fake payloads' do
    let(:body) { extract_dgfip_liasses_fiscales_payload(payload_name).to_json }

    describe 'with a payload which has repeated entries' do
      let(:payload_name) { 'one_obligation_fiscale' }

      it 'enrich the payload with dictionary data' do
        expect(enricher.bundled_data).to eq({})
      end
    end

    describe 'with a payload which has repeated obligations fiscales' do
      let(:payload_name) { 'two_obligations_fiscales' }

      it 'enrich the payload with dictionary data' do
        expect(enricher.bundled_data).to eq({})
      end
    end
  end
end
