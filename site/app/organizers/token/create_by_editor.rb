class Token::CreateByEditor < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackCreation

  before do
    context.event = :created
    context.name = "Jeton #{context.editor.name}".truncate(Token::NAME_MAX_LENGTH, omission: '')
    context.lifetime_in_months = Token::LIFETIMES_IN_MONTHS.max
    context.token_creation_source = 'editor'
  end

  organize Token::EnsureEditorMayGenerateToken,
    Token::SaveSelfServiceToken,
    Token::NotifyOtherContacts
end
