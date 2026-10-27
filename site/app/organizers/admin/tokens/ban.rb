class Admin::Tokens::Ban < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.banned',
    target: :token,
    actor: ADMIN_ACTOR,
    details_from_context: %i[blacklisted_at],
    computed_details: ->(context) { { datapass_id: context.token.authorization_request.external_id } }

  before do
    context.admin_activity_name = 'token_banned'
    context.admin_entity_key = :token
  end

  organize Admin::Tokens::BanToken,
    Admin::Tokens::RegenerateToken,
    Admin::Tokens::SendBanEmail,
    Admin::Tokens::CaptureBanAttributes,
    SecurityEvent::Track,
    Admin::TrackActivity
end
