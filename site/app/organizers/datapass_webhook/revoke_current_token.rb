class DatapassWebhook::RevokeCurrentToken < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackRevocations,
    EditorDelegation::TrackRevocations

  before do
    context.revoked_delegations = []
    context.delegation_revocation_source = 'datapass_revoke'
  end

  organize DatapassWebhook::RevokeCurrentTokenModel
end
