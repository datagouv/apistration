class Admin::Tokens::Ban < ApplicationOrganizer
  before do
    context.admin_activity_name = 'token_banned'
    context.admin_entity_key = :token
  end

  organize Admin::Tokens::BanToken,
    Admin::Tokens::SendBanEmail,
    Admin::Tokens::CaptureBanAttributes,
    Admin::TrackActivity
end
