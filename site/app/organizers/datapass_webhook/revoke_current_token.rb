class DatapassWebhook::RevokeCurrentToken < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackRevocation

  organize DatapassWebhook::RevokeCurrentTokenModel
end
