class MockService
  attr_reader :operation_id, :params

  class NoOperationId < StandardError; end
  class NoNotFoundPayload < StandardError; end

  def initialize(operation_id, params)
    @operation_id = operation_id
    @params = params.deep_transform_values { |v| v.is_a?(String) ? v.downcase : v }
  end

  def mock
    if api_entreprise?
      mock_from_backend ||
        mock_from_open_api
    else
      mock_from_backend ||
        mock_404
    end
  end

  def mock_from_backend
    MockDataBackend.get_response_for(operation_id, params)
  end

  def mock_from_open_api
    {
      payload: OpenAPISchemaToExample.new(response_schema_associated_to_operation_id).perform,
      status: 200
    }
  end

  def self.open_api_schema(schema_path)
    @open_api_schemas ||= {}
    @open_api_schemas[schema_path.to_s] ||= YAML.load_file(schema_path, aliases: true, permitted_classes: [Date])
  end

  private

  def mock_404
    MockDataBackend.get_not_found_response_for(operation_id) || (raise NoNotFoundPayload)
  end

  def response_schema_associated_to_operation_id
    path_schema_associated_to_operation_id[1]['get']['responses']['200']['content']['application/json']['schema']
  rescue NoMethodError
    raise NoOperationId
  end

  def path_schema_associated_to_operation_id
    open_api_schema['paths'].find do |_, schema|
      schema['get']['responses']['200']['x-operationId'] == operation_id
    end
  end

  def open_api_schema
    self.class.open_api_schema(schema_path)
  end

  def schema_path
    if api_entreprise?
      Rails.root.join('swagger/openapi-entreprise.yaml')
    elsif v2_api_particulier?
      Rails.root.join('swagger/openapi-particulierv2.yaml')
    else
      Rails.root.join('swagger/openapi-particulier.yaml')
    end
  end

  def v2_api_particulier?
    operation_id.include?('api_particulier_v2')
  end

  def api_entreprise?
    operation_id.include?('api_entreprise')
  end
end
