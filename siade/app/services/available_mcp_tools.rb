class AvailableMCPTools
  include Singleton

  def initialize
    Rails.root.glob('app/tools/**/*_tool.rb').each do |f|
      require f
    end
  end

  def perform(protected_data: false)
    all_available_tools = MCP::Tool.descendants - [ApplicationTool]
    protected_data ? all_available_tools : all_available_tools.reject(&:protected_data?)
  end
end
