module SelfServiceTokensManagement
  extend ActiveSupport::Concern

  def new
    @authorization_request = authorize(extract_authorization_request, :create_token?)
    @token = @authorization_request.tokens.new(name: nil)

    render 'shared/self_service_tokens/new'
  end

  def create
    authorization_request = authorize(extract_authorization_request, :create_token?)
    result = create_token_for(authorization_request)

    if result.success?
      success_message(title: t('shared.self_service_tokens.create.success.title', name: result.token.name))
    else
      error_message(title: t('shared.self_service_tokens.create.error.title'), description: result.message)
    end

    redirect_to authorization_request_path(id: authorization_request.id)
  end

  def revocation
    @token = authorize(extract_token, :revoke?)

    render 'shared/self_service_tokens/revocation'
  end

  def revoke
    token = authorize(extract_token, :revoke?)

    flash_revocation_outcome(Token::RevokeByContact.call(token:, user: current_user), token)

    redirect_to authorization_request_path(id: token.authorization_request.id)
  end

  private

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
      lifetime_in_months: token_params[:lifetime_in_months],
      allowed_ips_text: token_params[:allowed_ips_text]
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
    current_user.tokens.where(authorization_requests: { api: }).find(params.expect(:id))
  end

  def token_params
    params.expect(token: %i[name lifetime_in_months allowed_ips_text])
  end

  def api
    namespace.slice(4..-1)
  end
end
