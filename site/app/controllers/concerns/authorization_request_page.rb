module AuthorizationRequestPage
  extend ActiveSupport::Concern

  MODAL_FRAME = 'main-modal-content'.freeze

  private

  def render_authorization_request_page(authorization_request, status: :ok)
    @authorization_request = authorization_request
    @tokens = authorization_request.tokens.includes(:creator).order(created_at: :desc).decorate
    load_delegations_data

    render 'shared/authorization_requests/show', status:
  end

  def render_token_form(authorization_request, form, status: :ok, **locals)
    @authorization_request = authorization_request
    locals = { form:, form_locals: locals.merge(authorization_request:) }

    if turbo_frame_request_id == MODAL_FRAME
      render 'shared/authorization_requests/token_form_modal', locals:, status:, layout: false
    else
      render 'shared/authorization_requests/token_form_page', locals:, status:
    end
  end

  def load_delegations_data
    @active_delegations = @authorization_request.editor_delegations.active.includes(:editor)
    @available_editors = @authorization_request.available_editors_for_delegation
  end
end
