module AuthorizationRequestPage
  extend ActiveSupport::Concern

  private

  def render_authorization_request_page(authorization_request, panel: :token, selected_token: nil, status: :ok)
    @authorization_request = authorization_request
    @tokens = authorization_request.tokens.includes(:creator).order(created_at: :desc).decorate
    @panel = panel
    @selected_token = select_token(selected_token&.id || params[:jeton]) unless panel == :new
    load_delegations_data

    render 'shared/authorization_requests/show', status:
  end

  def select_token(token_id)
    @tokens.find { |token| token.id == token_id } || @tokens.find(&:active?) || @tokens.first
  end

  def load_delegations_data
    @active_delegations = @authorization_request.editor_delegations.active.includes(:editor)
    @available_editors = @authorization_request.available_editors_for_delegation
  end
end
