require 'open-uri'

root_path = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

api_particulier_open_api_file_content = ENV['LOCAL'].nil? ? URI.open('https://particulier.api.gouv.fr/api/open-api.yml').read : File.read(File.join(root_path, 'openapi_files/api-particulier.yml'))
api_particulier_schema = YAML.load(api_particulier_open_api_file_content, aliases: true, permitted_classes: [Date])
api_entreprise_schema = nil

def extract_path_spec_from_schema(operation_id, schema)
  schema['paths'].find do |_, schema|
    schema['get']['responses']['200']['x-operationId'] == operation_id
  end[1]['get']
end

RSpec.describe 'Payload specs' do
  Dir[File.join(root_path, 'payloads/*')].each do |operation_id|
    describe "operation #{operation_id.split('/')[-1]}" do
      Dir[File.join(operation_id, '*.yaml')].each do |payload|
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

            expect([200, 400, 401, 403, 404, 502]).to include(data['status'])
          end

          it 'has valid params according to OpenAPI file' do
            params = YAML.load_file(payload)['params']
            api_schema = operation_id.include?('api_particulier') ? api_particulier_schema : api_entreprise_schema
            path_spec = extract_path_spec_from_schema(File.basename(operation_id), api_schema)

            schema = {
              type: 'object',
              required: params.keys.reject { |param| path_spec['parameters'].find { |p| p['name'] == param }['required'] == false },
              properties: path_spec['parameters'].each_with_object({}) do |param_spec, acc|
                acc[param_spec['name']] = param_spec['schema']
              end
            }

            test = JSON::Validator.fully_validate(schema, params)
            expect(test).to be_empty, "JSON schema validation failed: #{test}"
          end

          it 'has a valid payload according to OpenAPI file' do
            data = YAML.load_file(payload)
            api_schema = operation_id.include?('api_particulier') ? api_particulier_schema : api_entreprise_schema
            path_spec = extract_path_spec_from_schema(File.basename(operation_id), api_schema)

            schema = path_spec['responses'][data['status'].to_s]['content']['application/json']['schema']

            test = JSON::Validator.fully_validate(schema, JSON.parse(data['payload']))
            expect(test).to be_empty, "JSON schema validation failed: #{test}"
          end
        end
      end
    end
  end
end
