RSpec.describe 'config/all_endpoints.yml' do
  let(:endpoints) { Rails.root.join('config/all_endpoints.yml').read }

  let(:swagger_file) { Rails.root.join('swagger/openapi.yaml') }
  let(:swagger) { Psych.safe_load_file(swagger_file) }
  let(:swagger_endpoints) { swagger['paths'].keys }
  let!(:swagger_endpoints_regex) { swagger_endpoints.map { |endpoint| regexify(endpoint) } }

  describe 'endpoints' do
    it 'has all endpoints in config/all_endpoints.yml' do
      swagger_endpoints_regex.each do |endpoint|
        expect(endpoints).to match(endpoint), "Endpoint #{endpoint} is missing from config/all_endpoints.yml"
      end
    end
  end

  def regexify(endpoint)
    regex_ready_string = endpoint.gsub(/{(.*?)}/, replacements)

    Regexp.new(regex_ready_string)
  end

  def replacements
    {
      '{siren}' => '\d{9}',
      '{siret}' => '\d{14}',
      '{siret_or_eori}' => '(\d{14}|\w{2}\d{13})',
      '{siret_or_rna}' => '(\d{14}|\w\d{9})',
      '{year}' => '\d{4}'
    }
  end
end
