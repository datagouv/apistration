class DatapassWebhook::FindOrCreateAuthorizationRequest < ApplicationOrganizer
  organize DatapassWebhook::FindOrCreateAuthorizationRequestModel,
    DatapassWebhook::TrackRoleChanges
end
