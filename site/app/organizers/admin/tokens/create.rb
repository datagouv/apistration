class Admin::Tokens::Create < ApplicationOrganizer
  before do
    context.admin_activity_name = 'token_created'
    context.admin_entity_key = :token
    context.token_creation_source = 'admin'
  end

  organize Admin::Tokens::ValidateExpiration,
    Admin::Tokens::CreateToken,
    Admin::Tokens::CaptureCreationAttributes,
    Token::TrackCreation,
    Admin::TrackActivity
end
