class AvailableMCPTools
  include Singleton

  def initialize
    Rails.root.glob('app/tools/**/*_tool.rb').each do |f|
      require f
    end
  end

  def perform
    MCP::Tool.descendants - [ApplicationTool]
  end
end
