module TokenExtensionsManagement
  extend ActiveSupport::Concern

  def new
    @token = authorize(extract_token, :extend?)

    render 'shared/token_extensions/new'
  end

  def create
    token = authorize(extract_token, :extend?)

    flash_extension_outcome(extend_token(token), token)

    redirect_to authorization_request_path(id: token.authorization_request.id)
  end

  private

  def extend_token(token)
    Token::ExtendByContact.call(token:, user: current_user, lifetime_in_months: params.expect(token: [:lifetime_in_months])[:lifetime_in_months])
  end

  def flash_extension_outcome(result, token)
    if result.success?
      success_message(title: t('shared.token_extensions.create.success.title', name: token.name, date: helpers.friendly_format_from_timestamp(token.exp)))
    else
      error_message(title: t('shared.token_extensions.create.error.title', name: token.name), description: result.message)
    end
  end

  def extract_token
    current_user.tokens.where(authorization_requests: { api: namespace.slice(4..-1) }).find(params.expect(:id))
  end
end
