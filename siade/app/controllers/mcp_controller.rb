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
      tools: AvailableMCPTools.instance.perform(protected_data: current_mcp_token.fetch(:protected_data, false)),
      server_context: {
        request_id: request.request_id
      }
    )
  end

  def authenticate_user!
    return if mcp_tokens.any? { |t| t[:value] == bearer_token_from_headers }

    render json: { error: 'Unauthorized' }, status: :unauthorized

    false
  end

  def bearer_token_from_headers
    auth = request.headers['Authorization']

    return unless auth

    matchs = auth.match(/\ABearer (.+)\z/)
    matchs[1] if matchs
  end

  def current_mcp_token
    @current_mcp_token ||= mcp_tokens.find { |t| t[:value] == bearer_token_from_headers }
  end

  def mcp_tokens
    @mcp_tokens ||= Siade.credentials[:mcp_tokens]
  end
end
