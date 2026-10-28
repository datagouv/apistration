class Token::CreateByContact < ApplicationOrganizer
  before do
    context.event = :created
  end

  organize Token::SaveSelfServiceToken,
    Token::NotifyOtherContacts
end
