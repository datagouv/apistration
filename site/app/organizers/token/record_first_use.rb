class Token::RecordFirstUse < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.first_used',
    target: :token,
    actor: ->(_context) { SecurityEvent::API_CLIENT_ACTOR.dup },
    details_from_context: %i[first_used_at],
    computed_details: ->(context) { { datapass_id: context.token.authorization_request.external_id } },
    only_if: ->(context) { context.token_flagged }

  organize Token::FlagFirstUse,
    SecurityEvent::Track
end
