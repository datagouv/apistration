# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractProviderFromPath, type: :service do
  it 'works with all paths from swagger' do
    open_api_path = Rails.root.join('swagger/openapi-entreprise.yaml')
    open_api = YAML.load_file(open_api_path)

    open_api['paths'].each do |path, data|
      next if path == '/privileges'
      next if data['get']['security'] == []

      expect(described_class.new(path).perform).to be_present, "#{path} has no associated provider"
    end
  end

  it 'only names providers the errors backend can prefix' do
    unknown = described_class::PROVIDER_FROM_URL_TO_HUMANIZED.reject do |_url_fragment, provider_name|
      ErrorsBackend.instance.provider_code_from_name(provider_name)
    end

    expect(unknown).to be_empty,
      "provider names with no prefix in ErrorsBackend: #{unknown.inspect}"
  end
end
