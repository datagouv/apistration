class Token::ExtendByContact < ApplicationOrganizer
  before do
    context.event = :extended
  end

  organize Token::ExtendToken,
    Token::NotifyOtherContacts
end
