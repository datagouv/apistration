class Editor::API::V1::DelegationsController < Editor::API::BaseController
  def index
    paginated = delegations_scope.page(params[:page]).per(per_page)

    render json: {
      data: paginated.map { |d| Editor::API::V1::DelegationSerializer.new(d).as_json },
      meta: pagination_meta(paginated)
    }
  end

  private

  def delegations_scope
    current_editor.editor_delegations
      .joins(:authorization_request)
      .merge(AuthorizationRequest.for_api(current_api))
      .preload(:authorization_request)
      .order(created_at: :desc)
  end
end
