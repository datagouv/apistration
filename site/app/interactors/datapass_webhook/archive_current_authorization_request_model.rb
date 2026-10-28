class DatapassWebhook::ArchiveCurrentAuthorizationRequestModel < ApplicationInteractor
  def call
    return unless context.event == 'archive'

    active_delegations = context.authorization_request.editor_delegations.active.to_a
    context.authorization_request.archive!
    context.revoked_delegations = active_delegations
  end
end
