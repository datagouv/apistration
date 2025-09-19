class MCPController < ActionController::API
  before_action :authenticate_user!

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
      tools: AvailableMCPTools.instance.perform
    )
  end

  def authenticate_user!
    return if Siade.credentials[:mcp_token] == bearer_token_from_headers

    render json: { error: 'Unauthorized' }, status: :unauthorized

    false
  end

  def bearer_token_from_headers
    auth = request.headers['Authorization']

    return unless auth

    matchs = auth.match(/\ABearer (.+)\z/)
    matchs[1] if matchs
  end
end
