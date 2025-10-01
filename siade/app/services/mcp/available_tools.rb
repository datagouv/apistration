class MCP::AvailableTools
  include Singleton

  def initialize
    Rails.root.glob('app/tools/**/*_tool.rb').each do |f|
      require f
    end
  end

  def perform(scopes:)
    all_available_tools.select do |tool|
      tool.scopes.intersect?(scopes)
    end
  end

  def all_available_tools
    @all_available_tools ||= MCP::Tool.descendants - [ApplicationTool]
  end
end
