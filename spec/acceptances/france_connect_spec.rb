RSpec.describe 'FranceConnect specs' do
  Dir[File.join(root_path, 'payloads/france_connect/*.yaml')].each do |payload|
    describe "Payload #{File.basename(payload)}" do
      it 'is a valid YAML file' do
        expect { YAML.load_file(payload) }.not_to raise_error
      end

      it 'has a valid json for "payload" key' do
        data = YAML.load_file(payload)

        expect { JSON.parse(data['payload']) }.not_to raise_error
      end

      it 'has a 200 status code' do
        data = YAML.load_file(payload)

        data['status'] == 200
      end

      it 'has only a token param' do
        data = YAML.load_file(payload)

        data['params'].keys == ['token']
        expect(data['params']['token']).to be_a(String)
      end

      it 'has a valid payload according to OpenAPI file' do
        data = YAML.load_file(payload)
        schema = File.read(File.join(root_path, 'spec', 'france_connect_json_schema.json'))
        test = JSON::Validator.fully_validate(schema, JSON.parse(data['payload']))

        expect(test).to be_empty, "JSON schema validation failed: #{test}"
      end
    end
  end
end

