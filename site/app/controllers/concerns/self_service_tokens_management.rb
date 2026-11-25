module SelfServiceTokensManagement
  extend ActiveSupport::Concern
  include AuthorizationRequestPage
  include TokenModalDenial

  def new
    authorization_request = authorize(extract_authorization_request, :create_token?)
    token = authorization_request.tokens.new(name: nil)

    render_token_form(authorization_request, 'shared/self_service_tokens/form', token:)
  end

  def create
    authorization_request = authorize(extract_authorization_request, :create_token?)
    result = create_token_for(authorization_request)

    if result.success?
      success_message(title: t('shared.self_service_tokens.create.success.title', name: result.token.name))
      redirect_to authorization_request_path(id: authorization_request.id)
    else
      render_creation_failure(authorization_request, result)
    end
  end

  def revocation
    token = authorize(extract_token, :revoke?)

    render_token_form(token.authorization_request, 'shared/self_service_tokens/revocation_form', token:)
  end

  def revoke
    token = authorize(extract_token, :revoke?)

    flash_revocation_outcome(Token::RevokeByContact.call(token:, user: current_user), token)

    redirect_to authorization_request_path(id: token.authorization_request.id)
  end

  private

  def render_creation_failure(authorization_request, result)
    token = result.token
    token.errors.add(:base, result.message) if token.errors.empty?

    render_token_form(authorization_request, 'shared/self_service_tokens/form', token:, status: :unprocessable_content)
  end

  def flash_revocation_outcome(result, token)
    if result.success? || token.reload.blacklisted?
      success_message(title: t('shared.self_service_tokens.revoke.success.title', name: token.name))
    else
      error_message(title: t('shared.self_service_tokens.revoke.error.title', name: token.name))
    end
  end

  def create_token_for(authorization_request)
    Token::CreateByContact.call(
      authorization_request:,
      user: current_user,
      name: token_params[:name],
      lifetime_in_months: token_params[:lifetime_in_months]
    )
  end

  def extract_authorization_request
    current_user
      .authorization_requests
      .where(api:)
      .viewable_by_users
      .find(params.expect(:authorization_request_id))
  end

  def extract_token
    current_user.tokens.where(authorization_requests: { api: }).merge(AuthorizationRequest.viewable_by_users).find(params.expect(:id))
  end

  def token_params
    params.expect(token: %i[name lifetime_in_months])
  end

  def api
    namespace.slice(4..-1)
  end
end
