class Token::RevokeByContact < ApplicationOrganizer
  before do
    context.event = :revoked
  end

  organize Token::RevokeToken,
    Token::NotifyOtherContacts
end
