RSpec.describe CNAV::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(token:, params:, dss_prestation_name: 'complementaire_sante_solidaire') }

  let(:token) { 'super_valid_token' }
  let(:request_id) { SecureRandom.uuid }

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
        recipient: valid_siret,
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnav_complementaire_sante_solidaire_url]).with(
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
        body: read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json')
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

    context 'when performing a request with transcoging params' do
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
          recipient: valid_siret,
          nom_commune_naissance: 'Paris',
          code_cog_insee_departement_naissance: '75',
          request_id:
        }
      end

      let!(:stubbed_request) do
        stub_request(:get, Siade.credentials[:cnav_complementaire_sante_solidaire_url]).with(
          query: {
            codeLieuNaissance: '17300',
            codePaysNaissance: '99100',
            dateNaissance: '1980-06-12',
            genre: 'M',
            listePrenoms: 'JEAN-PASCAL',
            nomNaissance: 'CHAMPION',
            villeNaissance: 'Paris',
            depNaissance: '75'
          },
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer super_valid_token',
            'X-APIPART-FSFINAL' => valid_siret,
            'X-Correlation-ID' => request_id
          }
        ).to_return(
          status: 200,
          body: read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json')
        )
      end

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'calls url with valid body, which interpolates params' do
        make_call

        expect(stubbed_request).to have_been_requested
      end
    end

    context 'when passing downcase sexe_etat_civil m instead of M (non-regression test)' do
      let(:params) do
        {
          nom_naissance: 'CHAMPION',
          prenoms: ['JEAN-PASCAL'],
          annee_date_naissance: 1980,
          mois_date_naissance: 6,
          jour_date_naissance: 12,
          sexe_etat_civil: 'm',
          code_cog_insee_pays_naissance: '99100',
          code_cog_insee_commune_naissance: '17300',
          recipient: valid_siret,
          request_id:
        }
      end

      it 'calls url with upcase sexe_etat_civil' do
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
        mois_date_naissance: 0o1,
        jour_date_naissance: 0o1,
        code_cog_insee_commune_naissance: '75101',
        code_cog_insee_pays_naissance: '99100',
        sexe_etat_civil: 'M',
        recipient: valid_siret,
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnav_complementaire_sante_solidaire_url]).with(
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
        body: read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json')
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

  describe 'when not from france' do
    let(:params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_naissance: 1980,
        mois_date_naissance: 6,
        jour_date_naissance: 12,
        sexe_etat_civil: 'M',
        code_cog_insee_pays_naissance: '00123',
        code_cog_insee_commune_naissance: '17300',
        recipient: valid_siret,
        request_id:
      }
    end

    let!(:stubbed_request) do
      stub_request(:get, Siade.credentials[:cnav_complementaire_sante_solidaire_url]).with(
        query: {
          codePaysNaissance: '00123',
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
        body: read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json')
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
