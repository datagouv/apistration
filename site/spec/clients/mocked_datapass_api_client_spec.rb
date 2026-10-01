RSpec.describe MockedDatapassAPIClient do
  describe '#list_formulaires' do
    subject(:formulaires) { described_class.new.list_formulaires('api_entreprise') }

    it 'serves the formulaires of the definition as the DataPass API does' do
      marches_publics = formulaires.find { |formulaire| formulaire['uid'] == 'api-entreprise-marches-publics' }

      expect(marches_publics).to include('prefilled?' => true)
      expect(marches_publics['data']).to include(
        'cadre_juridique_nature' => 'R2143-13 Code de la commande publique',
        'scopes' => include('unites_legales_etablissements_insee', 'attestation_fiscale_dgfip')
      )
    end

    it 'raises a not found error for an unknown definition' do
      expect { described_class.new.list_formulaires('unknown') }.to raise_error(DatapassAPIClient::NotFound)
    end
  end
end
