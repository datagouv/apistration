# frozen_string_literal: true

RSpec.describe 'OpenAPI file', type: :acceptance do
  context 'API v2 definition' do
    let(:definition_path) { 'public/v2/open-api.yml' }

    it 'is a valid YAML' do
      expect(YAML.load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end
  end

  context 'API v3 (and more) definition' do
    let(:definition_path) { 'swagger/v3/openapi.yaml' }

    it 'is a valid YAML' do
      expect(YAML.load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end
  end
end
