RSpec.describe 'config/endpoints_with_test_case.yml' do
  let(:endpoints) { Rails.root.join('config/endpoints_with_test_case.yml').read }

  let(:swagger_file) { Rails.root.join('swagger/openapi-entreprise.yaml') }
  let(:swagger) { Psych.safe_load_file(swagger_file) }
  let(:swagger_endpoints) { swagger['paths'].keys }
  let!(:swagger_endpoints_regex) { swagger_endpoints.map { |endpoint| regexify(endpoint) } }

  describe 'endpoints' do
    it 'has all endpoints in config/endpoints_with_test_case.yml' do
      swagger_endpoints_regex.each do |endpoint|
        expect(endpoints).to match(endpoint), "Endpoint #{endpoint} is missing from config/endpoints_with_test_case.yml"
      end
    end
  end

  def regexify(endpoint)
    regex_ready_string = endpoint.gsub(/{(.*?)}/, '[^/]+')

    Regexp.new(regex_ready_string)
  end
end
