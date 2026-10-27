class DatapassWebhook::ArchiveCurrentAuthorizationRequestModel < ApplicationInteractor
  def call
    return unless context.event == 'archive'
    return unless token_already_exists?

    active_delegations = context.authorization_request.editor_delegations.active.to_a
    context.authorization_request.archive!
    context.revoked_delegations = active_delegations
  end

  private

  def token_already_exists?
    context.authorization_request.token.present?
  end
end
