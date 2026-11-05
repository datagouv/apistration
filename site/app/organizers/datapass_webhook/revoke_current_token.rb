class DatapassWebhook::RevokeCurrentToken < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackRevocation,
    EditorDelegation::TrackRevocations

  before do
    context.revoked_delegations = []
    context.delegation_revocation_source = 'datapass_revoke'
  end

  organize DatapassWebhook::RevokeCurrentTokenModel
end
