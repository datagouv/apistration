class Token::RevokeByContact < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackRevocation

  before do
    context.event = :revoked
  end

  organize Token::RevokeToken,
    Token::NotifyOtherContacts
end
