class Token::CreateByContact < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackCreation

  before do
    context.event = :created
    context.token_creation_source = 'contact'
  end

  organize Token::SaveSelfServiceToken,
    Token::NotifyOtherContacts
end
