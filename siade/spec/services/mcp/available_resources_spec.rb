RSpec.describe MCP::AvailableResources do
  describe '#perform' do
    subject(:resources) { described_class.instance.perform }

    it 'returns MCP resources' do
      expect(resources.first).to be_a(MCP::Resource)
    end

    describe 'a resource' do
      subject(:resource) { resources.find { |res| res.name == 'INSEE - Unités légales' } }

      its(:uri) { is_expected.to eq('tool://api-entreprise/insee_unite_legale/documentation') }
      its(:name) { is_expected.to eq('INSEE - Unités légales') }
      its(:mime_type) { is_expected.to eq('text/markdown') }

      describe 'description' do
        subject(:description) { resource.description }

        it 'includes name of the tool with technical name' do
          expect(description).to include('INSEE - Unités légales (nom technique : `insee.unite_legale`)')
        end

        it 'includes description from swagger' do
          expect(description).to include('Informations de référence')
        end

        it 'includes a example 200 responses as json' do
          expect(description).to include('"pseudonyme":"DJ Falcon"')
        end

        it 'includes explanation of each field as json' do
          expect(description).to include('{"siren":{"title":"Siren de l\'unité légale"')
        end

        it 'includes a link to the documentation' do
          expect(description).to include('catalogue/insee/unites_legales')
        end
      end
    end
  end
end
