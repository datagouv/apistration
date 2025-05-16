RSpec.describe 'Payload specs' do
  Dir['payloads/*'].map { |path| path.gsub("payloads/", "") }.each do |operation_id|
    next if %w[france_connect README.md].include?(operation_id)

    describe do
      Dir[File.join('payloads', operation_id, '*.y*ml')].each do |payload|
        describe "Payload #{File.basename(payload)}" do
          it 'is a valid YAML file' do
            expect { YAML.load_file(payload) }.not_to raise_error
          end

          it 'has a valid json for "payload" key' do
            data = YAML.load_file(payload)

            expect { JSON.parse(data['payload']) }.not_to raise_error
          end

          it 'has a valid status code' do
            data = YAML.load_file(payload)

            expect([200, 400, 403, 404, 409, 429, 500, 502, 503, 504, 509]).to include(data['status'])
          end

          it 'has a use case description' do
            data = YAML.load_file(payload)

            expect(data['description']).not_to be_empty
          end

          if operation_id.split('/')[-1].start_with?('api_entreprise')
            it 'does not have tracking params' do
              param_keys = YAML.load_file(payload)['params'].keys

              expect(param_keys).not_to include('context', 'recipient', 'object')
            end
          end

          it 'has valid params according to OpenAPI file' do
            params = YAML.load_file(payload)['params']
            path_spec = extract_path_spec_from_schema(operation_id, load_schema(operation_id))
            required_params = params.keys.reject do |param|
              valid_param = path_spec['parameters'].find { |p| p['name'] == param }

              valid_param.nil? || valid_param['required'] == false
            end

            schema = {
              type: 'object',
              required: required_params,
              properties: path_spec['parameters'].each_with_object({}) do |param_spec, acc|
                acc[param_spec['name']] = param_spec['schema']
              end
            }

            test = JSON::Validator.fully_validate(schema, params)
            expect(test).to be_empty, "JSON schema validation failed: #{test}"
          end

          it 'has a valid payload according to OpenAPI file' do
            data = YAML.load_file(payload)
            main_schema = load_schema(operation_id)
            path_spec = extract_path_spec_from_schema(File.basename(operation_id), main_schema)

            schema = path_spec['responses'][data['status'].to_s]['content']['application/json']['schema']

            if schema['$ref']
              schema = main_schema['components']['schemas'][schema['$ref'].split('/').last]
            end

            test = JSON::Validator.fully_validate(convert_open_api_3_to_json_schema(schema), JSON.parse(data['payload']))
            expect(test).to be_empty, "JSON schema validation failed: #{test}"

          end
        end
      end
    end
  end
end
