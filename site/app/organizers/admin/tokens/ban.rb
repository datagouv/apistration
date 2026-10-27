class Admin::Tokens::Ban < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackBan,
    Token::TrackCreation

  before do
    context.admin_activity_name = 'token_banned'
    context.admin_entity_key = :token
    context.token_creation_source = 'admin_ban'
  end

  organize Admin::Tokens::BanToken,
    Admin::Tokens::RegenerateToken,
    Admin::Tokens::SendBanEmail,
    Admin::Tokens::CaptureBanAttributes,
    Admin::TrackActivity
end
