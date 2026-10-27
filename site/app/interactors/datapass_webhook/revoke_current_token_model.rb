class DatapassWebhook::RevokeCurrentTokenModel < ApplicationInteractor
  def call
    return unless context.event == 'revoke'
    return unless token_already_exists?

    context.authorization_request.revoke!
    context.revoked_token = context.authorization_request.token&.reload
  end

  private

  def token_already_exists?
    context.authorization_request.token.present?
  end
end
