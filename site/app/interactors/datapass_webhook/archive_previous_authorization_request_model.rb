# frozen_string_literal: true

class DatapassWebhook::ArchivePreviousAuthorizationRequestModel < ApplicationInteractor
  def call
    return if %w[approve validate].exclude?(context.event)
    return if context.authorization_request.previous_external_id.blank?

    previous_authorization_request = find_previous_authorization_request
    return if previous_authorization_request.blank?

    archive(previous_authorization_request)
  end

  private

  def find_previous_authorization_request
    AuthorizationRequest.find_by(external_id: context.authorization_request.previous_external_id)
  end

  def archive(authorization_request)
    active_delegations = authorization_request.editor_delegations.active.to_a
    authorization_request.archive!
    context.revoked_delegations = active_delegations
  end
end
