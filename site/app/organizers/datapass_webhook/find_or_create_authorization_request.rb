class DatapassWebhook::FindOrCreateAuthorizationRequest < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with DatapassWebhook::TrackRoleChanges

  organize DatapassWebhook::FindOrCreateAuthorizationRequestModel
end
