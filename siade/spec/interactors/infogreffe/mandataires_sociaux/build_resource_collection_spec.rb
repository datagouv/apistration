RSpec.describe Infogreffe::MandatairesSociaux::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
    subject(:call) { described_class.call(response: response) }

    let(:valid_pp) do
      {
        id: 'HISQUIN-FRANCOIS-1965-01-27',
        type: 'pp',
        nom: 'HISQUIN',
        prenom: 'FRANCOIS',
        fonction: 'PRESIDENT DU DIRECTOIRE',
        date_naissance: '1965-01-27',
        lieu_naissance: 'ROUBAIX',
        pays_naissance: 'FRANCE',
        code_pays_naissance: 'FR',
        nationalite: 'FRANCAISE',
        code_nationalite: 'FR',
        date_naissance_timestamp: -155_523_600
      }
    end

    let(:valid_pm) do
      {
        id: '784824153',
        type: 'pm',
        fonction: 'COMMISSAIRE AUX COMPTES TITULAIRE',
        raison_sociale: 'MAZARS - SOCIETE ANONYME',
        code_greffe: '9201',
        libelle_greffe: 'NANTERRE',
        identifiant: '784824153'
      }
    end

    let(:valid_meta) do
      {
        count_pp: 10,
        count_pm: 2,
        count: 12
      }
    end

    let(:response) do
      instance_double('Net::HTTPOK', body: body)
    end

    let(:body) do
      Infogreffe::MandatairesSociaux::MakeRequest.call(params: params).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:extrait_rcs)
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(subject.resource_collection).to all be_a(Resource)
    end

    it 'has exactly 2 resources' do
      expect(call.resource_collection.count).to eq(12)
    end

    it 'has valid meta' do
      expect(call.meta).to eq(valid_meta)
    end

    it 'contain valid pp' do
      expect(call.resource_collection.map(&:to_h)).to include(valid_pp)
    end

    it 'contain valid pm' do
      expect(call.resource_collection.map(&:to_h)).to include(valid_pm)
    end
  end
end
