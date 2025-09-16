class McpController < ActionController::API
  def handle
    if params[:method] == 'notifications/initialized'
      head :accepted
    else
      render(json: mcp_server.handle_json(request.body.read))
    end
  end

  private

  def mcp_server
    MCP::Server.new(
      name: 'siade',
      version: '1.0.0',
      tools: [INSEE::UniteLegaleDiffusableTool, QUALIBAT::CertificationsBatimentTool]
    )
  end
end
