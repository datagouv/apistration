module TokenExtensionsManagement
  extend ActiveSupport::Concern
  include AuthorizationRequestPage

  def new
    @token = authorize(extract_token, :extend?)

    render_extension_panel
  end

  def create
    @token = authorize(extract_token, :extend?)
    result = extend_token(@token)

    if result.success?
      flash_extension_success
      redirect_to authorization_request_path(id: @token.authorization_request.id, jeton: @token.id)
    else
      @extension_error = result.message
      render_extension_panel(status: :unprocessable_content)
    end
  end

  private

  def flash_extension_success
    success_message(title: t('shared.token_extensions.create.success.title', name: @token.name, date: helpers.friendly_format_from_timestamp(@token.exp)))
  end

  def render_extension_panel(status: :ok)
    render_authorization_request_page(@token.authorization_request, panel: :extension, selected_token: @token, status:)
  end

  def extend_token(token)
    Token::ExtendByContact.call(token:, user: current_user, lifetime_in_months: params.expect(token: [:lifetime_in_months])[:lifetime_in_months])
  end

  def extract_token
    current_user.tokens.where(authorization_requests: { api: namespace.slice(4..-1) }).merge(AuthorizationRequest.viewable_by_users).find(params.expect(:id))
  end
end
