class Token::TrackCreation < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.created',
    target: :created_token,
    actor: ADMIN_ACTOR,
    computed_details: ->(context) { creation_details(context) },
    only_if: ->(context) { context.created_token&.persisted? }

  organize SecurityEvent::Track

  def self.creation_details(context)
    token = context.created_token

    {
      source: context.token_creation_source,
      datapass_id: token.authorization_request.external_id,
      expires_at: Time.zone.at(token.exp),
      scopes: token.scopes
    }
  end
end
