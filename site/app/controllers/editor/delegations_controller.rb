class Editor::DelegationsController < EditorController
  def index
    @delegations = current_editor
      .editor_delegations
      .joins(:authorization_request)
      .merge(AuthorizationRequest.for_api(namespace))
      .includes(authorization_request: %i[organization demandeur])
      .order(created_at: :desc)
      .page(params[:page])
  end
end
