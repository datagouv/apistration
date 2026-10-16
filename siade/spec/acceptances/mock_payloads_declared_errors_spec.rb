RSpec.describe 'Mock payloads naming a declared error' do
  mock_paths = Rails.root.glob('config/mock_payloads/*/*.y{a,}ml')
    .select { |path| YAML.load_file(path).key?('declared_error') }

  mock_paths.each do |path|
    mock = "#{path.dirname.basename}/#{path.basename}"

    it "#{mock} names a known error declaration" do
      MockDataBackend.reset!

      expect { MockDataBackend.get_not_found_response_for(path.dirname.basename.to_s) }.not_to raise_error
    end

    it "#{mock} renders the error its declaration builds" do
      content = YAML.load_file(path)
      declared = content['declared_error'].constantize.build(provider_name: 'CNAV').to_h.deep_stringify_keys

      expect(JSON.parse(content['payload'])['errors'].first).to eq(declared)
    end
  end
end
