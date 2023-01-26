require 'yaml'
require 'json'
require 'date'
require 'open-uri'

module OpenApiHelpers
  def root_path
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def load_schema(operation_id)
    @api_kind_to_schema ||= {}

    if ENV['LOCAL']
      content_schema = load_local_schema(operation_id)
    else
      content_schema = load_schema_from_remote(operation_id)
    end

    @api_kind_to_schema[extract_open_api_name(operation_id)] ||= YAML.load(content_schema, aliases: true, permitted_classes: [Date])
  end

  def load_local_schema(operation_id)
    file_path = File.join(root_path, 'openapi_files', "#{extract_open_api_name(operation_id)}.yaml")
    file_content = File.read(file_path)
  end

  def load_schema_from_remote(operation_id)
    uri = case extract_open_api_name(operation_id)
          when 'api_particulier'
            'https://staging.particulier.api.gouv.fr/api/open-api.yml'
          else
            'https://staging.entreprise.api.gouv.fr/v3/openapi.yaml'
          end

    $remote_schemas ||= {}
    $remote_schemas[uri] ||= URI.open(uri).read
  end

  def extract_open_api_name(operation_id)
    base_name = File.basename(operation_id)
    if base_name.start_with?('api_particulier')
      'api_particulier'
    else
      'api_entreprise'
    end
  end

  def extract_path_spec_from_schema(operation_id, schema)
    schema['paths'].find do |_, schema|
      schema['get']['responses']['200']['x-operationId'] == operation_id
    end[1]['get']
  end
end

OpenAPIHelpers = OpenApiHelpers
