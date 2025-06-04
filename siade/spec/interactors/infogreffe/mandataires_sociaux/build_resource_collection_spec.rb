RSpec.describe Infogreffe::MandatairesSociaux::BuildResourceCollection, type: :build_resource do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      Infogreffe::MakeRequest.call(params:).response.body
    end

    let(:params) do
      { siren: }
    end

    let(:resource_collection) { call.bundled_data.data }

    context 'with a SIREN for personne morale', vcr: { cassette_name: 'infogreffe/with_valid_siren_personne_morale' } do
      let(:siren) { valid_siren(:extrait_rcs) }

      let(:valid_pp) do
        {
          type: 'personne_physique',
          nom: 'DURANT',
          prenom: 'ALEX',
          fonction: 'PRESIDENT DU DIRECTOIRE',
          date_naissance: '1980-02-15',
          lieu_naissance: 'PARIS',
          pays_naissance: 'FRANCE',
          code_pays_naissance: 'FR',
          nationalite: 'FRANCAISE',
          code_nationalite: 'FR',
          date_naissance_timestamp: 319_417_200
        }
      end

      let(:valid_pm) do
        {
          numero_identification: '123456789',
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

      it { is_expected.to be_a_success }

      it 'builds valid resource' do
        expect(resource_collection).to all be_a(Resource)
      end

      it 'has exactly 2 resources' do
        expect(resource_collection.count).to eq(12)
      end

      it 'has valid meta' do
        meta = call.bundled_data.context

        expect(meta).to eq(valid_meta)
      end

      it 'contain valid pp' do
        expect(resource_collection.map(&:to_h)).to include(valid_pp)
      end

      it 'contain valid pm' do
        expect(resource_collection.map(&:to_h)).to include(valid_pm)
      end

      context 'when no greffe code in mandataires sociaux payload',
        vcr: { cassette_name: 'infogreffe/with_valid_siren_no_greffe_code' } do
          it 'does not raise' do
            expect { call }.not_to raise_error
          end
        end
    end

    context 'with a SIREN for personne physique', vcr: { cassette_name: 'infogreffe/with_valid_siren_personne_physique' } do
      let(:siren) { valid_siren(:extrait_rcs_personne_physique) }

      let(:valid_pp) do
        {
          type: 'personne_physique',
          nom: 'SPLOUSHY',
          prenom: 'FANCY MCFACE',
          fonction: nil,
          date_naissance: '1971-02-26',
          lieu_naissance: 'UNEVILLE',
          pays_naissance: 'FRANCE',
          code_pays_naissance: 'FR',
          nationalite: nil,
          code_nationalite: nil,
          date_naissance_timestamp: 36_370_800
        }
      end

      let(:valid_meta) do
        {
          personnes_physiques_count: 1,
          personnes_morales_count: 0,
          count: 1
        }
      end

      it { is_expected.to be_a_success }

      it 'builds valid resource' do
        expect(resource_collection.first).to be_a(Resource)
      end

      it 'returns only one result' do
        expect(resource_collection.count).to eq(1)
      end

      it 'has valid meta' do
        meta = call.bundled_data.context

        expect(meta).to eq(valid_meta)
      end

      it 'contain valid pp' do
        expect(resource_collection.first.to_h).to eq(valid_pp)
      end
    end

    context 'when payload has no Personne Physique naissance data' do
      let(:body) do
        open_payload_file('infogreffe/without_personne_physique_naissance.xml').read
      end

      let(:valid_pp) do
        {
          code_nationalite: nil,
          code_pays_naissance: nil,
          date_naissance: nil,
          date_naissance_timestamp: nil,
          fonction: 'LAQUALITE',
          lieu_naissance: nil,
          nationalite: nil,
          nom: 'LAPERSONNEPHYSIQUE',
          pays_naissance: nil,
          prenom: nil,
          type: 'personne_physique'
        }
      end

      it { is_expected.to be_a_success }

      it 'contain valid pp' do
        expect(resource_collection.first.to_h).to eq(valid_pp)
      end
    end
  end
end
