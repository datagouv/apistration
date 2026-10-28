class Token::CreateByEditor < ApplicationOrganizer
  before do
    context.event = :created
    context.name = "Jeton #{context.editor.name}".truncate(Token::NAME_MAX_LENGTH, omission: '')
    context.lifetime_in_months = Token::LIFETIMES_IN_MONTHS.max
  end

  organize Token::EnsureEditorMayGenerateToken,
    Token::SaveSelfServiceToken,
    Token::NotifyOtherContacts
end
