RSpec.describe CNAF::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(token:, params:, dss_prestation_name: 'complementaire_sante_solidaire') }

  let(:token) { 'super_valid_token' }
  let(:request_id) { SecureRandom.uuid }

  describe 'with civility params' do
    let(:params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_de_naissance: 1980,
        mois_date_de_naissance: 6,
        jour_date_de_naissance: 12,
        gender: 'M',
        code_pays_lieu_de_naissance: '99100',
        code_insee_lieu_de_naissance: '17300',
        recipient: valid_siret,
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnaf_complementaire_sante_solidaire_url]).with(
        query: {
          codeLieuNaissance: '17300',
          codePaysNaissance: '99100',
          dateNaissance: '1980-06-12',
          genre: 'M',
          listePrenoms: 'JEAN-PASCAL',
          nomNaissance: 'CHAMPION'
        },
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer super_valid_token',
          'X-APIPART-FSFINAL' => valid_siret,
          'X-Correlation-ID' => request_id
        }
      ).to_return(
        status: 200,
        body: read_payload_file('cnaf/complementaire_sante_solidaire/make_request_valid.json')
      )
    end

    context 'when performing a request' do
      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'calls url with valid body, which interpolates params' do
        make_call

        expect(stubbed_request).to have_been_requested
      end
    end
  end

  describe 'with FranceConnect params' do
    let(:params) do
      {
        nom_usage: 'MARTIN',
        nom_naissance: 'DUPONT',
        prenoms: %w[Jean Martin],
        date_naissance: '2000-01-01',
        code_insee_lieu_de_naissance: '75101',
        code_pays_lieu_de_naissance: '99100',
        gender: 'M',
        recipient: valid_siret,
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnaf_complementaire_sante_solidaire_url]).with(
        query: hash_including({
          codeLieuNaissance: '75101',
          codePaysNaissance: '99100',
          dateNaissance: '2000-01-01',
          genre: 'M',
          listePrenoms: 'Jean Martin',
          nomNaissance: 'DUPONT',
          nomUsage: 'MARTIN'
        }),
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer super_valid_token',
          'X-Correlation-ID' => request_id,
          'X-APIPART-FSFINAL' => valid_siret
        }
      ).to_return(
        status: 200,
        body: read_payload_file('cnaf/complementaire_sante_solidaire/make_request_valid.json')
      )
    end

    context 'when performing a request' do
      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'calls url with valid body, which interpolates params' do
        make_call

        expect(stubbed_request).to have_been_requested
      end
    end
  end
end
