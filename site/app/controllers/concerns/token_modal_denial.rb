module TokenModalDenial
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :deny_unauthorized_token_action
    rescue_from ActiveRecord::RecordNotFound, with: :deny_missing_token
  end

  private

  def deny_unauthorized_token_action
    return render_token_modal_denial(:forbidden) if token_modal_request?

    logged_user_not_authorized
  end

  def deny_missing_token
    return render_token_modal_denial(:not_found) if token_modal_request?

    error_message(title: t('application_controller.error.record_not_found'))
    redirect_current_user_to_homepage
  end

  def token_modal_request?
    turbo_frame_request_id == AuthorizationRequestPage::MODAL_FRAME
  end

  def render_token_modal_denial(status)
    render 'shared/authorization_requests/token_modal_denial', layout: false, status:, locals: { back_path: url_from(request.referer) || authorization_requests_path }
  end
end
