class Token::Reveal < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.revealed',
    target: :token,
    computed_details: ->(context) { { surface: 'user', datapass_id: context.token.authorization_request.external_id } },
    only_if: ->(context) { !context.impersonating }

  organize SecurityEvent::Track
end
