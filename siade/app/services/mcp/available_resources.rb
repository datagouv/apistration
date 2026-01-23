class MCP::AvailableResources
  include Singleton

  def perform
    tool_resources
  end

  private

  def tool_resources
    @tool_resources ||= mcp_resources_config.keys.map do |resource_name|
      build_tool_resource(resource_name.to_s)
    end
  end

  def build_tool_resource(resource_name)
    class_name = resource_name.tr('.', '/').camelize
    tool = Kernel.const_get("#{class_name}Tool")

    MCP::Resource.new(
      uri: "tool://api-entreprise/#{resource_name.tr('.', '_')}/documentation",
      name: tool.title,
      description: build_tool_description(tool),
      mime_type: 'text/markdown'
    )
  end

  def build_tool_description(tool)
    MCPResourceDescriptionBuilder.new(
      tool
    ).render
  end

  def mcp_resources_config
    @mcp_resources_config ||= Rails.application.config_for('mcp/resources').deep_stringify_keys
  end
end
