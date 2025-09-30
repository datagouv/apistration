class MCPController < ActionController::API
  include HandleTokens

  skip_before_action :authorize_access_to_resource!, unless: :tool_calling?

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
      tools: AvailableMCPTools.instance.perform(scopes: current_user.scopes),
      server_context: {
        request_id: request.request_id,
        user_id: current_user.id
      }
    )
  end

  def user_not_authorized
    render json: { error: 'not_authorized' }, status: :unauthorized
  end

  def user_no_longer_authorized
    render json: { error: 'token_expired' }, status: :unauthorized
  end

  def tool_calling?
    mcp_params[:method] == 'tools/call'
  end

  def resource_name
    "mcp/#{mcp_params[:params][:name]}"
  end

  def mcp_params
    if params[:mcp]
      params.expect(mcp: [:method, { params: {} }])
    else
      params.permit(:method, params: {})
    end
  end
end
