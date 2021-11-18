module MockableInStaging
  extend ActiveSupport::Concern

  included do
    before_action :mock_response, if: :staging?
    rescue_from OpenAPISchemaToExample::InvalidOpenAPIType, with: :invalid_open_api_type
  end

  def mock_response
    render json: json, status: :ok
  end

  def staging?
    Rails.env.staging?
  end

  def extract_valid_open_api_path_schema
    valid_schema[1]['get']['responses']['200']['content']['application/json']['schema']
  end

  def invalid_open_api_type
    errors << OpenAPIExampleError.new

    MonitoringService
      .instance
      .capture_message("Unknown type: #{$ERROR_INFO.message}", level: 'warning')

    render json: ErrorsSerializer.new(errors, format: error_format).as_json,
      status: :internal_server_error
  end

  private

  def json
    OpenAPISchemaToExample.new(extract_valid_open_api_path_schema).perform
  end

  def valid_schema
    open_api_schema['paths'].find do |_, schema|
      schema['get']['operationId'] == "#{controller_name}_#{action_name}"
    end
  end

  def open_api_schema
    YAML.load_file(schema_path)
  end

  def schema_path
    Rails.root.join('public/v2/open-api.yml')
  end

  def errors
    @errors ||= []
  end
end
