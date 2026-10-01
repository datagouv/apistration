class DatapassWebhook::ArchiveRefusedEditorDelegationRequest < ApplicationInteractor
  def call
    return if %w[refuse refuse_application].exclude?(context.event)
    return if context.reopening
    return unless context.authorization_request.editor_delegation_request?

    context.authorization_request.archive!
  end
end
