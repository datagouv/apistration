RSpec.describe ScopeHelper do
  include described_class

  let(:scope_catalog) { instance_double(ScopeCatalog) }

  before do
    allow(ScopeCatalog).to receive(:for).and_return(scope_catalog)
  end

  describe '#humanize_scope' do
    before do
      allow(scope_catalog).to receive(:lookup).and_return(catalog_entry)
    end

    context 'when the api is api_entreprise (2 levels: provider || name)' do
      let(:catalog_entry) { { provider: 'INSEE', group: 'Informations générales', name: 'Données unités légales et établissements' } }

      it 'returns provider || name, ignoring group' do
        expect(humanize_scope('unites_legales_etablissements_insee', 'api_entreprise'))
          .to eq('INSEE || Données unités légales et établissements')
      end
    end

    context 'when the api is api_particulier (3 levels: provider || group || name)' do
      let(:catalog_entry) { { provider: 'CNAF & MSA', group: 'API Quotient familial', name: 'Identités allocataire et conjoint' } }

      it 'returns provider || group || name' do
        expect(humanize_scope('cnaf_allocataires', 'api_particulier'))
          .to eq('CNAF & MSA || API Quotient familial || Identités allocataire et conjoint')
      end
    end

    context 'when the scope is unknown to the catalog' do
      let(:catalog_entry) { nil }

      it 'falls back to the "Autres" group with scope.humanize' do
        expect(humanize_scope('totally_unknown_scope', 'api_entreprise'))
          .to eq('Autres || Totally unknown scope')
      end
    end

    context 'when the resolved entry has every field blank' do
      let(:catalog_entry) { { provider: nil, group: nil, name: nil } }

      it 'still produces a splittable 3-part string for api_particulier' do
        expect(humanize_scope('totally_blank_scope', 'api_particulier'))
          .to eq('Autres || Autres || Totally blank scope')
      end

      it 'still produces a splittable 2-part string for api_entreprise' do
        expect(humanize_scope('totally_blank_scope', 'api_entreprise'))
          .to eq('Autres || Totally blank scope')
      end
    end
  end

  describe '#build_scopes' do
    context 'when the api is api_particulier' do
      before do
        allow(scope_catalog).to receive(:lookup).with('cnaf_quotient_familial').and_return(
          provider: 'CNAF & MSA', group: 'API Quotient familial', name: 'Quotient familial CAF & MSA'
        )
        allow(scope_catalog).to receive(:lookup).with('cnaf_allocataires').and_return(
          provider: 'CNAF & MSA', group: 'API Quotient familial', name: 'Identités allocataire et conjoint'
        )
      end

      it 'nests scopes under provider then group' do
        result = build_scopes(%w[cnaf_quotient_familial cnaf_allocataires], 'api_particulier')

        expect(result).to eq({
          'CNAF & MSA' => {
            'API Quotient familial' => ['Quotient familial CAF & MSA', 'Identités allocataire et conjoint']
          }
        })
      end
    end

    context 'when the api is api_entreprise' do
      before do
        allow(scope_catalog).to receive(:lookup).with('unites_legales_etablissements_insee').and_return(
          provider: 'INSEE', group: 'Informations générales', name: 'Données unités légales et établissements'
        )
      end

      it 'nests scopes directly under provider, ignoring group' do
        result = build_scopes(%w[unites_legales_etablissements_insee], 'api_entreprise')

        expect(result).to eq({ 'INSEE' => ['Données unités légales et établissements'] })
      end
    end

    context 'when a scope is not found in the catalog' do
      before do
        allow(scope_catalog).to receive(:lookup).with('totally_unknown_scope').and_return(nil)
      end

      it 'still shows the scope, under the fallback "Autres" group' do
        result = build_scopes(['totally_unknown_scope'], 'api_entreprise')

        expect(result).to eq({ 'Autres' => ['Totally unknown scope'] })
      end
    end

    context 'when an api_particulier scope has a blank group but a sibling from the same provider has a real group' do
      before do
        allow(scope_catalog).to receive(:lookup).with('cnaf_allocataires').and_return(
          provider: 'CNAF & MSA', group: 'API Quotient familial', name: 'Real Label'
        )
        allow(scope_catalog).to receive(:lookup).with('cnaf_no_group').and_return(
          provider: 'CNAF & MSA', group: nil, name: 'No Group Label'
        )
      end

      it "keeps the nil-group scope's real name visible instead of losing it" do
        result = build_scopes(%w[cnaf_allocataires cnaf_no_group], 'api_particulier')

        expect(result).to eq({
          'CNAF & MSA' => {
            'API Quotient familial' => ['Real Label'],
            'Autres' => ['No Group Label']
          }
        })
      end
    end
  end
end
