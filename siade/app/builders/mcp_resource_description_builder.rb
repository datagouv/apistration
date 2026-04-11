class MCPResourceDescriptionBuilder < ApplicationBuilder
  attr_reader :tool, :resource_data, :swagger_data

  def initialize(tool)
    @tool = tool
    @resource_data = extract_resource_data(tool.tool_name)
    @swagger_data = swagger['paths'][resource_data[:url_path]]
  end

  def self.resources_config
    AppConfig.fetch('mcp/resources#stringify_keys') do
      Rails.application.config_for('mcp/resources').deep_stringify_keys
    end
  end

  protected

  def tool_name
    tool.title
  end

  def tool_technical_name
    tool.tool_name
  end

  def summary
    swagger_data['get']['description']
  end

  def example
    OpenAPISchemaToExample.new(success_response_schema).perform
  end

  def documentation_url
    resource_data['documentation_url']
  end

  def success_response_schema
    swagger_data['get']['responses']['200']['content']['application/json']['schema']
  end

  def template_name
    'mcp_resource_description.md.erb'
  end

  private

  def swagger
    APIEntrepriseSwaggerData.instance.swagger
  end

  def extract_resource_data(tool_name)
    self.class.resources_config[tool_name]
  end
end
