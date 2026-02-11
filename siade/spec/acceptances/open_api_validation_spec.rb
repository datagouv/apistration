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

  context 'API Particulier v2 definition' do
    let(:definition_path) { 'swagger/openapi-particulierv2.yaml' }

    it 'is a valid YAML' do
      expect(YAML.unsafe_load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end
  end

  context 'API Particulier v3 (and more) definition' do
    let(:definition_path) { 'swagger/openapi-particulier.yaml' }

    it 'is a valid YAML' do
      expect(YAML.load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end

    it 'has all required keys for each endpoint' do
      YAML.load_file(definition_path)['paths'].each do |path, data|
        next if path == '/privileges'

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

    it 'has a 200 response with an x-operationId' do
      YAML.load_file(definition_path)['paths'].each do |path, data|
        expect(data['get']['responses']['200']['x-operationId']).not_to be_nil, "#{path} has no 200 response with an x-operationId"
      end
    end
  end

  context 'API Entreprise v3 (and more) definition' do
    let(:definition_path) { 'swagger/openapi-entreprise.yaml' }

    it 'is a valid YAML' do
      expect(YAML.load_file(definition_path)).to be_truthy
    end

    it 'is a valid configuration' do
      document = Openapi3Parser.load_file(definition_path)
      expect(document).to be_valid, "Errors: #{document.errors.to_h}"
    end

    it 'has all required keys for each endpoint' do
      YAML.load_file(definition_path)['paths'].each do |path, data|
        next if path == '/privileges'

        required_keys = %w[
          tags
          description
        ]
        actual_keys = data['get'].keys

        expect(actual_keys).to include(*required_keys), "#{path} has missing keys: #{required_keys - actual_keys}"
      end
    end

    it 'has a 200 response with an x-operationId' do
      YAML.load_file(definition_path)['paths'].each do |path, data|
        expect(data['get']['responses']['200']['x-operationId']).not_to be_nil, "#{path} has no 200 response with an x-operationId"
      end
    end

    it 'has a valid description for each endpoint' do
      description_inherited_by_latest_response_definition = 'Le jeton ne possède pas les droits nécessaires'

      YAML.load_file(definition_path)['paths'].each do |path, data|
        expect(data['get']['description']).not_to eq(description_inherited_by_latest_response_definition), "#{path} has an invalid description"
      end
    end

    it 'marks version N-1 as deprecated when version N exists' do
      paths = YAML.load_file(definition_path)['paths']
      paths_by_suffix_and_version = Hash.new { |hash, key| hash[key] = {} }

      paths.each do |path, data|
        match = path.match(%r{\A/v(?<version>\d+)(?<suffix>/.*)\z})
        next unless match
        next unless data['get']

        version = match[:version].to_i
        suffix = match[:suffix]
        paths_by_suffix_and_version[suffix][version] = data['get']
      end

      errors = []

      paths_by_suffix_and_version.each do |suffix, versions|
        versions.keys.sort.each do |version|
          previous_version = version - 1
          next unless versions.key?(previous_version)
          next if versions[previous_version]['deprecated'] == true

          errors << "/v#{previous_version}#{suffix} should be deprecated because /v#{version}#{suffix} exists"
        end
      end

      expect(errors).to be_empty, errors.join("\n")
    end
  end
end
# rubocop:enable Rails/DeprecatedActiveModelErrorsMethods
