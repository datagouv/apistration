class OpenAPISchemaToExample
  attr_reader :schema

  class InvalidOpenAPIType < StandardError; end

  def initialize(schema)
    @schema = schema
  end

  def perform
    if schema['type']
      handle_with_type_key(schema)
    elsif schema['oneOf']
      perform_recursively(schema['oneOf'].sample)
    else
      unknown_type(schema)
    end
  end

  private

  def handle_with_type_key(schema)
    case schema['type']
    when 'array'
      extract_array_value(schema['items'])
    when 'object'
      extract_object_value(schema['properties'])
    when 'string', 'integer', 'number', 'boolean', 'date', 'null'
      extract_value(schema)
    else
      unknown_type(schema)
    end
  end

  def unknown_type(open_api_schema)
    raise InvalidOpenAPIType, open_api_schema.to_h
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

  def extract_value(sub_schema)
    sub_schema['example'] ||
      extract_default_value(sub_schema)
  end

  def extract_default_value(sub_schema)
    case sub_schema['type']
    when 'string'
      'dummy'
    when 'integer', 'number'
      rand(50)
    when 'boolean'
      true
    when 'date'
      Date.new(2023, 1, 31)
    when 'null'
      nil
    end
  end
end
