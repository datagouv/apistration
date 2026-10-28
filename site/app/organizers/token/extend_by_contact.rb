class Token::ExtendByContact < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackProlongation

  before do
    context.event = :extended
    context.token_prolongation_source = 'contact'
  end

  organize Token::ExtendToken,
    Token::NotifyOtherContacts
end
