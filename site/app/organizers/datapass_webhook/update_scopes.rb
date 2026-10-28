class DatapassWebhook::UpdateScopes < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackScopesChanges

  organize DatapassWebhook::UpdateScopesModel
end
