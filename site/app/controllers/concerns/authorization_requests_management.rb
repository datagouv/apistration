module AuthorizationRequestsManagement
  extend ActiveSupport::Concern
  include AuthorizationRequestPage

  def show
    render_authorization_request_page(extract_authorization_request)
  rescue ActiveRecord::RecordNotFound
    error_message(title: t('concerns.authorization_requests_management.show.error.title'))

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
      ).includes(:user_authorization_request_roles, :organization)

    render 'shared/authorization_requests/index'
  end

  private

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
