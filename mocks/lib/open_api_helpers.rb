require 'yaml'
require 'json'
require 'date'

module OpenApiHelpers
  def root_path
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def load_schema(operation_id)
    @api_kind_to_schema ||= {}

    name = extract_open_api_name(operation_id)
    relative = case name
               when 'api_entreprise'      then 'commons/swagger/openapi-entreprise.yaml'
               when 'api_particulier'     then 'commons/swagger/openapi-particulier.yaml'
               when 'api_particulier_v2'  then 'commons/swagger/api_particulier_open_api_static/v2.yaml'
               end

    @api_kind_to_schema[name] ||= YAML.load(File.read(File.join(root_path, relative)), aliases: true, permitted_classes: [Date])
  end

  def extract_open_api_name(operation_id)
    base_name = File.basename(operation_id)
    if base_name.start_with?('api_particulier_v2')
      'api_particulier_v2'
    elsif base_name.match?(/\Aapi_particulier_v[3-9]/) || base_name.match?(/\Aapi_particulier_v\d{2,}/)
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

      if open_api_schema['nullable']
        open_api_schema['type'] = [open_api_schema['type'], 'null']
        open_api_schema.delete('nullable')
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
