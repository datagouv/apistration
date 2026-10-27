class DatapassWebhook::ArchiveCurrentAuthorizationRequest < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with EditorDelegation::TrackRevocations

  before do
    context.revoked_delegations = []
    context.delegation_revocation_source = 'datapass_archive'
  end

  organize DatapassWebhook::ArchiveCurrentAuthorizationRequestModel
end
