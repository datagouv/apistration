RSpec.describe DatapassFormulaire do
  describe '.find' do
    subject(:formulaire) { described_class.find(uid) }

    let(:uid) { 'api-entreprise-marches-publics' }

    before { stub_datapass_formulaires }

    it 'returns the prefilled data of the formulaire' do
      expect(formulaire.data).to eq(
        'cadre_juridique_nature' => 'Marchés publics',
        'cadre_juridique_url' => 'https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000037703425/',
        'scopes' => %w[entreprises etablissements]
      )
    end

    it 'reads the formulaires of the API Entreprise definition once' do
      2.times { described_class.find(uid) }

      expect(DatapassAPIClient.new).to have_received(:list_formulaires).with('api_entreprise').once
    end

    context 'when the formulaire is not prefilled' do
      let(:uid) { 'api-entreprise' }

      it 'returns empty data' do
        expect(formulaire.data).to eq({})
      end
    end

    context 'when the formulaire does not exist' do
      let(:uid) { 'unknown' }

      it 'raises a not found error' do
        expect { formulaire }.to raise_error(DatapassFormulaire::NotFound)
      end
    end
  end
end
