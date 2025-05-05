RSpec.describe CNAV::QuotientFamilialV2::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(token:, params:, dss_prestation_name: 'quotient_familial_v2', recipient:) }

  let(:token) { 'super_valid_token' }
  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

  describe 'with civility params' do
    let(:params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_naissance: 1980,
        mois_date_naissance: 6,
        jour_date_naissance: 12,
        sexe_etat_civil: 'M',
        code_cog_insee_pays_naissance: '99100',
        code_cog_insee_commune_naissance: '17300',
        annee: 2024,
        mois:,
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnav_quotient_familial_v2_url]).with(
        query: {
          codeLieuNaissance: '17300',
          codePaysNaissance: '99100',
          dateNaissance: '1980-06-12',
          genre: 'M',
          listePrenoms: 'JEAN-PASCAL',
          nomNaissance: 'CHAMPION',
          anneeDemandee: 2024,
          moisDemande: '08'
        },
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer super_valid_token',
          'X-APIPART-FSFINAL' => valid_siret,
          'X-Correlation-ID' => request_id
        }
      ).to_return(
        status: 200,
        body: read_payload_file('cnav/quotient_familial_v2/make_request_valid.json')
      )
    end

    context 'when performing a request' do
      let(:mois) { 8 }

      it { is_expected.to be_a_success }
      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'calls url with valid body, which interpolates params' do
        make_call
        expect(stubbed_request).to have_been_requested
      end
    end

    context 'when month is prefixed by 0' do
      let(:mois) { '08' }

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
        annee_date_naissance: 2000,
        mois_date_naissance: 1,
        jour_date_naissance: 1,
        code_cog_insee_commune_naissance: '75101',
        code_cog_insee_pays_naissance: '99100',
        sexe_etat_civil: 'M',
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnav_quotient_familial_v2_url]).with(
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
        body: read_payload_file('cnav/quotient_familial_v2/make_request_valid.json'),
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
