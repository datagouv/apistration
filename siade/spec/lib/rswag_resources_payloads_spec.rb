require 'rails_helper'

RSpec.describe RSwagResourcesPayloads do # rubocop:disable RSpec/SpecFilePathFormat
  include described_class

  describe '#promote_scopes_to_extensions!' do
    it 'renames scope: to x-scope on a flat attribute' do
      schema = { 'type' => 'string', 'scope' => 'cnaf_quotient_familial' }

      promote_scopes_to_extensions!(schema)

      expect(schema).to eq('type' => 'string', 'x-scope' => 'cnaf_quotient_familial')
    end

    it 'preserves an array value (multiple scopes opening the same field)' do
      schema = { 'scope' => %w[prime_activite prime_activite_majoration] }

      promote_scopes_to_extensions!(schema)

      expect(schema['x-scope']).to eq(%w[prime_activite prime_activite_majoration])
      expect(schema).not_to have_key('scope')
    end

    it 'walks into properties of object attributes' do
      schema = {
        'type' => 'object',
        'properties' => {
          'inner' => { 'type' => 'string', 'scope' => 'inner_scope' }
        }
      }

      promote_scopes_to_extensions!(schema)

      expect(schema['properties']['inner']).to eq('type' => 'string', 'x-scope' => 'inner_scope')
    end

    it 'walks into items of array attributes' do
      schema = {
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'inner' => { 'type' => 'string', 'scope' => 'inner_scope' }
          }
        }
      }

      promote_scopes_to_extensions!(schema)

      expect(schema['items']['properties']['inner']).to eq('type' => 'string', 'x-scope' => 'inner_scope')
    end

    it 'is idempotent' do
      schema = { 'type' => 'string', 'scope' => 'foo' }

      promote_scopes_to_extensions!(schema)
      promote_scopes_to_extensions!(schema)

      expect(schema).to eq('type' => 'string', 'x-scope' => 'foo')
    end

    it 'leaves attributes without scope untouched' do
      schema = { 'type' => 'string', 'description' => 'no scope here' }

      promote_scopes_to_extensions!(schema)

      expect(schema).to eq('type' => 'string', 'description' => 'no scope here')
    end
  end

  describe '#add_required_keys_to_all_type_object' do
    it 'promotes scope keys while computing required keys' do
      attributes = {
        'quotient_familial' => { 'type' => 'integer', 'scope' => 'cnaf_quotient_familial' },
        'allocataires' => {
          'type' => 'array',
          'scope' => 'cnaf_allocataires',
          'items' => {
            'type' => 'object',
            'properties' => {
              'nom' => { 'type' => 'string' }
            }
          }
        }
      }

      add_required_keys_to_all_type_object(attributes)

      expect(attributes['quotient_familial']).to include('x-scope' => 'cnaf_quotient_familial')
      expect(attributes['quotient_familial']).not_to have_key('scope')
      expect(attributes['allocataires']).to include('x-scope' => 'cnaf_allocataires')
    end
  end
end
