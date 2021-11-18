class OpenAPISchemaToExample
  attr_reader :schema

  class InvalidOpenAPIType < StandardError; end

  def initialize(schema)
    @schema = schema
  end

  # rubocop:disable Metrics/AbcSize
  def perform
    case schema['type']
    when 'array'
      extract_array_value(schema['items'])
    when 'object'
      extract_object_value(schema['properties'])
    when 'string'
      extract_value(schema, 'dummy')
    when 'integer'
      extract_value(schema, rand(50))
    when 'boolean'
      extract_value(schema, true)
    else
      unknown_type(schema)
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def unknown_type(open_api_schema)
    raise InvalidOpenAPIType, open_api_schema.to_s
  end

  def extract_array_value(value)
    [
      perform_recursively(value)
    ].flatten
  end

  def extract_object_value(properties)
    properties.to_h.transform_values do |value|
      perform_recursively(value)
    end
  end

  def perform_recursively(value)
    self.class.new(value).perform
  end

  def extract_value(sub_schema, default)
    sub_schema['example'] ||
      default
  end
end
