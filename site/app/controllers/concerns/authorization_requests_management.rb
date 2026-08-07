module AuthorizationRequestsManagement
  extend ActiveSupport::Concern

  def show
    @authorization_request = extract_authorization_request
    @tokens = @authorization_request.tokens.order(created_at: :desc).decorate
    load_delegations_data

    render 'shared/authorization_requests/show'
  rescue ActiveRecord::RecordNotFound
    error_message(title: t('.error.title'))

    redirect_current_user_to_homepage
  end

  def index
    @authorization_requests = current_user
      .authorization_requests
      .where(api:)
      .submitted_at_least_once
      .viewable_by_users
      .order(
        first_submitted_at: :desc
      ).includes(:user_authorization_request_roles)

    render 'shared/authorization_requests/index'
  end

  private

  def load_delegations_data
    @active_delegations = @authorization_request.editor_delegations.active.includes(:editor)
    @available_editors = @authorization_request.available_editors_for_delegation
  end

  def extract_authorization_request
    current_user
      .authorization_requests
      .where(api:)
      .viewable_by_users
      .find(params.expect(:id))
  end

  def api
    namespace.slice(4..-1)
  end
end
