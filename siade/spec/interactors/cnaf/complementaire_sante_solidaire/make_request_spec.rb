RSpec.describe CNAF::ComplementaireSanteSolidaire::MakeRequest, type: :make_request do
  subject(:make_call) { described_class.call(token:, params:) }

  let(:token) { 'super_valid_token' }
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
      user_siret: valid_siret,
      request_id:
    }
  end

  let(:request_id) { SecureRandom.uuid }

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
      body: Rails.root.join('spec/fixtures/payloads/cnaf/complementaire_sante_solidaire/make_request_valid.json').read
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
