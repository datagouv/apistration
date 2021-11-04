class OpenAPISchemaToExample
  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

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
      'FIXME'
    end
  end

  private

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
