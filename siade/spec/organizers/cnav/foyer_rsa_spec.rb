RSpec.describe CNAV::FoyerRSA, type: :retriever_organizer do
  subject(:organizer) { described_class.call(params:, recipient:) }

  let(:recipient) { valid_siret }
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
      request_id: SecureRandom.uuid
    }
  end

  before do
    stub_cnav_authenticate('foyer_rsa')
  end

  context 'when the CNAV returns a foyer with a beneficiary and a dependant' do
    before { stub_cnav_valid('foyer_rsa') }

    it { is_expected.to be_a_success }

    it 'maps the foyer to the API Particulier signature' do
      expect(organizer.bundled_data.data.to_h).to eq(
        beneficiaires: [
          {
            nom_naissance: 'DUPONT',
            nom_usage: 'DURANT',
            prenoms: 'Jeanne',
            date_naissance: '1970-11-25',
            sexe: 'F',
            qualite: 'allocataire'
          }
        ],
        personnes_a_charge: [
          {
            nom_naissance: 'DUPONT',
            nom_usage: nil,
            prenoms: 'Clotaire Kevin',
            date_naissance: '2007-06-16',
            sexe: 'M'
          }
        ]
      )
    end

    it 'takes the regime as data source' do
      expect(organizer.data_source).to eq('CNAF')
    end
  end

  context 'when the foyer is a couple without dependants' do
    before do
      stub_request(:get, cnav_url('foyer_rsa')).with(query: hash_including({})).to_return(
        status: 200,
        body: read_payload_file('cnav/foyer_rsa/make_request_couple_without_dependants.json')
      )
    end

    it 'returns both beneficiaries and an empty list of dependants' do
      data = organizer.bundled_data.data.to_h

      expect(data[:beneficiaires].pluck(:qualite)).to eq(%w[allocataire conjoint])
      expect(data[:personnes_a_charge]).to eq([])
    end
  end

  context 'when the CNAV answers 200 without any beneficiary' do
    before do
      stub_request(:get, cnav_url('foyer_rsa')).with(query: hash_including({})).to_return(
        status: 200,
        body: { foyer: { beneficiaire: [] } }.to_json
      )
    end

    it { is_expected.to be_a_failure }

    it 'reports an unknown provider response' do
      expect(organizer.errors).to include(instance_of(ProviderUnknownError))
    end
  end

  context 'when the person is not found' do
    before { stub_cnav_404('foyer_rsa', 'CNAF') }

    it { is_expected.to be_a_failure }

    it 'returns the CNAF not found error of the regime' do
      expect(organizer.errors.first.code).to eq('23003')
    end
  end

  context 'when the CNAV rejects the civility' do
    before { stub_cnav_400('foyer_rsa', error_code: 40_003, error: "Format du nom de naissance ou du nom d'usage erroné") }

    it { is_expected.to be_a_failure }

    it 'returns the rejected civility error' do
      expect(organizer.errors.first).to be_a(ProviderUnprocessableEntityError)
    end
  end

  context 'with invalid params' do
    let(:params) { super().merge(sexe_etat_civil: 'invalid') }

    it { is_expected.to be_a_failure }
  end
end
