class API::V2::BaseController < ::API::AuthenticateEntityController
  before_action :mock_response, if: :staging?

  protected

  def content_type_header
    'application/json'
  end

  def mock_response
    render json: OpenAPISchemaToExample.new(extract_valid_open_api_path_schema).perform,
      status: :ok
  end

  def staging?
    Rails.env.staging?
  end

  def extract_valid_open_api_path_schema
    valid_schema[1]['get']['responses']['200']['content']['application/json']['schema']
  end

  private

  def valid_schema
    open_api_schema['paths'].find do |_, schema|
      schema['get']['controller_action'] == "#{controller_name}_#{action_name}"
    end
  end

  def open_api_schema
    YAML.load_file(schema_path)
  end

  def schema_path
    Rails.root.join('public/v2/open-api.yml')
  end
end
