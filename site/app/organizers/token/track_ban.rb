class Token::TrackBan < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.banned',
    target: :token,
    actor: ADMIN_ACTOR,
    details_from_context: %i[blacklisted_at],
    computed_details: ->(context) { { datapass_id: context.token.authorization_request.external_id } },
    only_if: ->(context) { context.token_banned }

  organize SecurityEvent::Track
end
