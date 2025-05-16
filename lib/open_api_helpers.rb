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
    File.read(file_path)
  end

  def load_schema_from_remote(operation_id)
    uri = case extract_open_api_name(operation_id)
          when 'api_particulier_v2'
            'https://staging.particulier.api.gouv.fr/api/open-api.yml'
          when 'api_particulier'
            'https://staging.particulier.api.gouv.fr/api/open-api-v3.yml'
          else
            'https://staging.entreprise.api.gouv.fr/open-api.yml'
          end

    $remote_schemas ||= {}
    $remote_schemas[uri] ||= URI.open(uri).read
  end

  def extract_open_api_name(operation_id)
    base_name = File.basename(operation_id)
    if base_name.start_with?('api_particulier_v2')
      'api_particulier_v2'
    elsif base_name.start_with?('api_particulier_v3')
      'api_particulier'
    else
      'api_entreprise'
    end
  end

  def extract_path_spec_from_schema(operation_id, schema)
    schema['paths'].find do |_, path|
      path['get']['responses']['200']['x-operationId'] == operation_id
    end[1]['get']
  end

  def convert_open_api_3_to_json_schema(open_api_schema)
    case open_api_schema['type']
    when 'array'
      open_api_schema['items'] = convert_open_api_3_to_json_schema(open_api_schema['items'])
    when 'object'
      if open_api_schema['properties']
        open_api_schema['properties'] = open_api_schema['properties'].each_with_object({}) do |(key, value), hash|
          hash[key] = convert_open_api_3_to_json_schema(value)
        end
      end
    else
      if open_api_schema['nullable']
        open_api_schema['type'] = [open_api_schema['type'], 'null']
        open_api_schema.delete('nullable')

        if open_api_schema['enum']
          open_api_schema['enum'] << nil
          open_api_schema['enum'].uniq!
        end
      end
    end

    open_api_schema
  end
end

OpenAPIHelpers = OpenApiHelpers
