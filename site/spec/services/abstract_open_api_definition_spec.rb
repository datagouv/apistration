require 'rails_helper'

RSpec.describe AbstractOpenAPIDefinition do
  subject(:definition) { APIEntreprise::OpenAPIDefinition.instance }

  describe '#open_api_partial_definition_content' do
    let(:backend) do
      {
        'info' => { 'title' => 'Test API' },
        'components' => { 'schemas' => {} },
        'paths' => {
          '/v3/foo/bar' => {
            'get' => {
              'responses' => {
                '200' => { 'x-operationId' => 'api_entreprise_v3_foo_bar' }
              }
            }
          },
          '/v3/baz/qux' => {
            'get' => {
              'responses' => {
                '200' => { 'x-operationId' => 'api_entreprise_v3_baz_qux' }
              }
            }
          }
        }
      }
    end

    let(:original_backend) { definition.instance_variable_get(:@backend) }

    before do
      original_backend
      definition.instance_variable_set(:@backend, backend)
    end

    after do
      definition.instance_variable_set(:@backend, original_backend)
    end

    it 'returns only the path matching the given operation_id' do
      result = YAML.safe_load(definition.open_api_partial_definition_content(%w[api_entreprise_v3_foo_bar]))

      expect(result['paths'].keys).to contain_exactly('/v3/foo/bar')
    end

    it 'returns multiple paths when multiple operation_ids are given' do
      result = YAML.safe_load(
        definition.open_api_partial_definition_content(
          %w[api_entreprise_v3_foo_bar api_entreprise_v3_baz_qux]
        )
      )

      expect(result['paths'].keys).to contain_exactly('/v3/foo/bar', '/v3/baz/qux')
    end

    it 'preserves all top-level keys outside paths' do
      result = YAML.safe_load(definition.open_api_partial_definition_content(%w[api_entreprise_v3_foo_bar]))

      expect(result['info']).to eq({ 'title' => 'Test API' })
      expect(result['components']).to eq({ 'schemas' => {} })
    end

    it 'returns empty paths when no operation_ids match' do
      result = YAML.safe_load(definition.open_api_partial_definition_content(%w[nonexistent]))

      expect(result['paths']).to be_empty
    end

    it 'returns empty paths when called with an empty array' do
      result = YAML.safe_load(definition.open_api_partial_definition_content([]))

      expect(result['paths']).to be_empty
    end
  end
end
