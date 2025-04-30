module InterceptWithOpenAPIMockedPayloadInStaging
  extend ActiveSupport::Concern

  class NoOperationId < StandardError; end

  included do
    before_action :mock_response, if: :staging?
    rescue_from OpenAPISchemaToExample::InvalidOpenAPIType, with: :invalid_open_api_type
    rescue_from NoOperationId, with: :operation_id_not_found
  end

  def mock_response
    mocked_response_for_staging
  end

  def mocked_response_for_staging
    render json: mocked_json, status: :ok
  end

  def staging?
    Rails.env.staging?
  end

  def extract_valid_open_api_path_schema
    valid_schema[1]['get']['responses']['200']['content']['application/json']['schema']
  rescue NoMethodError
    raise NoOperationId
  end

  def invalid_open_api_type
    track_open_api_errors("Unknown type: #{$ERROR_INFO.message}")
    render_open_api_errors
  end

  def operation_id_not_found
    track_open_api_errors("operationId not found: #{operation_id}")
    render_open_api_errors
  end

  private

  def current_module_name
    controller_path.classify.split('::')[1]
  end

  def v3_and_more?
    current_module_name == 'V3AndMore'
  end

  def render_open_api_errors
    errors << OpenAPIExampleError.new

    render json: ErrorsSerializer.new(errors).as_json,
      status: :internal_server_error
  end

  def track_open_api_errors(message)
    MonitoringService
      .instance
      .capture_message(message, level: 'warning')
  end

  def mocked_json
    OpenAPISchemaToExample.new(extract_valid_open_api_path_schema).perform
  end

  def valid_schema
    open_api_schema['paths'].find do |_, schema|
      schema['get']['responses']['200']['x-operationId'] == operation_id
    end
  end

  def open_api_schema
    YAML.load_file(schema_path, aliases: true)
  end

  def schema_path
    if v3_and_more?
      Rails.root.join('swagger/openapi-entreprise.yaml')
    else
      Rails.public_path.join('v2/open-api.yml')
    end
  end

  def errors
    @errors ||= []
  end
end
