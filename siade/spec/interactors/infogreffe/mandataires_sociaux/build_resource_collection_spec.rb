RSpec.describe Infogreffe::MandatairesSociaux::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
    subject(:call) { described_class.call(response:) }

    let(:valid_pp) do
      {
        type: 'personne_physique',
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
        numero_identification: '784824153',
        type: 'personne_morale',
        fonction: 'COMMISSAIRE AUX COMPTES TITULAIRE',
        raison_sociale: 'MAZARS - SOCIETE ANONYME',
        code_greffe: '9201',
        libelle_greffe: 'NANTERRE'
      }
    end

    let(:valid_meta) do
      {
        personnes_physiques_count: 10,
        personnes_morales_count: 2,
        count: 12
      }
    end

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      Infogreffe::MakeRequest.call(params:).response.body
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

    context 'when no greffe code in mandataires sociaux payload',
      vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren_no_greffe_code' } do
      it 'does not raise' do
        expect { call }.not_to raise_error
      end
    end
  end
end
