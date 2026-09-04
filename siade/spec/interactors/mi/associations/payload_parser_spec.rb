RSpec.describe MI::Associations::PayloadParser do
  describe '.call' do
    subject(:parsed) { described_class.call(body) }

    context 'with a scalar payload' do
      let(:body) do
        {
          id_correspondance: 1_065_861,
          identite: { util_publique: true, active: false, nom: '  LA  PREVENTION   ROUTIERE ', sigle: '   ' }
        }.to_json
      end

      it 'wraps the payload under the :asso key' do
        expect(parsed).to have_key(:asso)
      end

      it 'stringifies numbers' do
        expect(parsed[:asso][:id_correspondance]).to eq('1065861')
      end

      it 'stringifies booleans' do
        expect(parsed[:asso][:identite][:util_publique]).to eq('true')
        expect(parsed[:asso][:identite][:active]).to eq('false')
      end

      it 'collapses inner whitespace and trims' do
        expect(parsed[:asso][:identite][:nom]).to eq('LA PREVENTION ROUTIERE')
      end

      it 'maps blank strings to nil' do
        expect(parsed[:asso][:identite][:sigle]).to be_nil
      end
    end

    context 'with single-element collections' do
      let(:body) do
        {
          etablissements: [{ id_siret: '111' }, { id_siret: '222' }],
          agrements: [{ numero: '1' }],
          affiliations: [{ nom: 'FEDERATION' }],
          compositions: [{ nom: 'MEMBRE' }],
          representants_legaux: [{ nom: 'Martin' }]
        }.to_json
      end

      it 'wraps each collection with its singular element key' do
        expect(parsed[:asso][:etablissements]).to eq(etablissement: [{ id_siret: '111' }, { id_siret: '222' }])
        expect(parsed[:asso][:agrements]).to eq(agrement: [{ numero: '1' }])
        expect(parsed[:asso][:affiliations]).to eq(affiliation: [{ nom: 'FEDERATION' }])
        expect(parsed[:asso][:compositions]).to eq(membre: [{ nom: 'MEMBRE' }])
        expect(parsed[:asso][:representants_legaux]).to eq(representant_legal: [{ nom: 'Martin' }])
      end
    end

    context 'with exploded collections (comptes / rhs)' do
      let(:body) do
        { comptes: [{ annee: 2015, dons: 4065 }], rhs: [{ annee: 2024 }, { annee: 2023 }] }.to_json
      end

      it 'explodes a single entry into an array of single-key hashes' do
        expect(parsed[:asso][:comptes]).to eq(compte: [{ annee: '2015' }, { dons: '4065' }])
      end

      it 'explodes several entries into an array of arrays of single-key hashes' do
        expect(parsed[:asso][:rhs]).to eq(rh: [[{ annee: '2024' }], [{ annee: '2023' }]])
      end
    end

    context 'with empty collections' do
      let(:body) { { etablissements: [], comptes: [] }.to_json }

      it 'leaves them as blank arrays' do
        expect(parsed[:asso][:etablissements]).to eq([])
        expect(parsed[:asso][:comptes]).to eq([])
      end
    end
  end
end
