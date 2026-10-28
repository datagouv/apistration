class DatapassWebhook::RevokeCurrentToken < ApplicationInteractor
  def call
    return unless context.event == 'revoke'

    context.authorization_request.revoke!
  end
end
