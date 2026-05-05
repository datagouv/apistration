# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbstractOpenAPIDefinition do
  describe 'subclasses with real OpenAPI files' do
    subject(:definition) { APIEntreprise::OpenAPIDefinition.instance }

    describe '#open_api_filtered_by_provider_definition_content' do
      it 'returns valid YAML' do
        yaml = definition.open_api_filtered_by_provider_definition_content('insee')

        expect { YAML.safe_load(yaml, aliases: true, permitted_classes: [Date]) }.not_to raise_error
      end

      it 'keeps only paths whose second URL segment matches the provider slug' do
        yaml = definition.open_api_filtered_by_provider_definition_content('insee')
        parsed = YAML.safe_load(yaml, aliases: true, permitted_classes: [Date])

        expect(parsed['paths'].keys).to all(match(%r{\A/v\d+/insee/}))
        expect(parsed['paths']).not_to be_empty
      end

      it 'preserves info, tags and components unchanged' do
        full = YAML.safe_load(definition.open_api_definition_content, aliases: true, permitted_classes: [Date])
        filtered = YAML.safe_load(
          definition.open_api_filtered_by_provider_definition_content('insee'),
          aliases: true,
          permitted_classes: [Date]
        )

        expect(filtered['info']).to eq(full['info'])
        expect(filtered['tags']).to eq(full['tags'])
        expect(filtered['components']).to eq(full['components'])
      end

      it 'returns empty paths for an unknown provider' do
        yaml = definition.open_api_filtered_by_provider_definition_content('nonexistent_provider')
        parsed = YAML.safe_load(yaml, aliases: true, permitted_classes: [Date])

        expect(parsed['paths']).to eq({})
      end

      it 'excludes paths that have no provider segment' do
        yaml = definition.open_api_filtered_by_provider_definition_content('insee')
        parsed = YAML.safe_load(yaml, aliases: true, permitted_classes: [Date])

        expect(parsed['paths']).not_to have_key('/privileges')
      end
    end
  end
end
