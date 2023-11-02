# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractProviderFromPath, type: :service do
  it 'works with all paths from swagger' do
    open_api_path = Rails.root.join('swagger/openapi-entreprise.yaml')
    open_api = YAML.load_file(open_api_path)

    open_api['paths'].each do |path, _|
      next if path == '/privileges'

      expect(described_class.new(path).perform).to be_present, "#{path} has no associated provider"
    end
  end
end
