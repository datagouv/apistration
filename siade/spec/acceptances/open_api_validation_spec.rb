# frozen_string_literal: true

# rubocop:disable Rails/DeprecatedActiveModelErrorsMethods
RSpec.describe 'OpenAPI file', type: :acceptance do
  context 'API Entreprise v2 definition' do
    let(:definition_path) { 'public/v2/open-api.yml' }

    it 'is a valid YAML' do
      expect(YAML.load_file(definition_path, aliases: true)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end
  end

  context 'API Particulier definition' do
    let(:definition_path) { 'swagger/api-particulier-open-api.yml' }

    it 'is a valid YAML' do
      expect(YAML.unsafe_load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end
  end

  context 'API Particulier France connect definition' do
    let(:definition_path) { 'swagger/api-particulier-france-connect-open-api.yml' }

    it 'is a valid YAML' do
      expect(YAML.unsafe_load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end
  end

  context 'API Entreprise v3 (and more) definition' do
    let(:definition_path) { 'swagger/openapi.yaml' }

    it 'is a valid YAML' do
      expect(YAML.load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end

    it 'has all required keys for each endpoint' do
      YAML.load_file(definition_path)['paths'].each do |path, data|
        required_keys = %w[
          tags
          description
        ]
        actual_keys = data['get'].keys

        expect(actual_keys).to include(*required_keys), "#{path} has missing keys: #{required_keys - actual_keys}"
      end
    end

    it 'has a valid description for each endpoint' do
      description_inherited_by_latest_response_definition = 'Le jeton ne possède pas les droits nécessaires'

      YAML.load_file(definition_path)['paths'].each do |path, data|
        expect(data['get']['description']).not_to eq(description_inherited_by_latest_response_definition), "#{path} has an invalid description"
      end
    end
  end
end
# rubocop:enable Rails/DeprecatedActiveModelErrorsMethods
