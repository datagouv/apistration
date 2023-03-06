class MockService
  attr_reader :operation_id, :params

  class NoOperationId < StandardError; end

  def initialize(operation_id, params)
    @operation_id = operation_id
    @params = params
  end

  def mock
    mock_from_backend ||
      mock_from_open_api
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

  private

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
    YAML.load_file(schema_path, aliases: true, permitted_classes: [Date])
  end

  def schema_path
    if v2_api_entreprise?
      Rails.public_path.join('v2/open-api.yml')
    elsif api_entreprise?
      Rails.root.join('swagger/openapi-entreprise.yaml')
    else
      Rails.root.join('swagger/openapi-particulier.yaml')
    end
  end

  def api_entreprise?
    operation_id.include?('api_entreprise')
  end

  def v2_api_entreprise?
    operation_id.starts_with?('v2_api_entreprise')
  end
end
