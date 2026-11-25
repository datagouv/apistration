class DatapassWebhook::RevokeCurrentTokenModel < ApplicationInteractor
  def call
    return unless context.event == 'revoke'

    active_delegations = authorization_request.editor_delegations.active.to_a
    context.revoked_tokens = authorization_request.revoke!
    context.revoked_delegations = active_delegations
  end

  private

  def authorization_request
    context.authorization_request
  end
end
