RSpec.describe CNAF::QuotientFamilialV2::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(token:, params:) }

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
        user_id: valid_siret,
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnaf_quotient_familial_v2_url]).with(
        query: {
          codeLieuNaissance: '17300',
          codePaysNaissance: '99100',
          dateNaissance: '1980-06-12',
          genre: 'M',
          listePrenoms: 'JEAN-PASCAL',
          nomNaissance: 'CHAMPION',
          anneeDemandee: Time.zone.today.year,
          moisDemande: Time.zone.today.month
        },
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer super_valid_token',
          'X-APIPART-FSFINAL' => valid_siret,
          'X-Correlation-ID' => request_id
        }
      ).to_return(
        status: 200,
        body: read_payload_file('cnaf/quotient_familial_v2/make_request_valid.json')
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
        nom_usage: 'jdupont',
        nom_naissance: 'DUPONT',
        prenoms: %w[Jean Martin],
        date_naissance: '2000-01-01',
        code_insee_lieu_de_naissance: '75101',
        code_pays_lieu_de_naissance: '99100',
        gender: 'M',
        user_id: 'france_connect_client_name',
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnaf_quotient_familial_v2_url]).with(
        query: hash_including({
          codeLieuNaissance: '75101',
          codePaysNaissance: '99100',
          dateNaissance: '2000-01-01',
          genre: 'M',
          listePrenoms: 'Jean Martin',
          nomNaissance: 'DUPONT',
          nomUsage: 'jdupont'
        }),
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer super_valid_token',
          'X-Correlation-ID' => request_id,
          'X-APIPART-FSFINAL' => 'france_connect_client_name'
        }
      ).to_return(
        status: 200,
        body: read_payload_file('cnaf/quotient_familial_v2/make_request_valid.json'),
        headers: {
          'X-APISECU-FD' => '00810011'
        }
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
