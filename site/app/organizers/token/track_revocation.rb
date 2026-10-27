class Token::TrackRevocation < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.revoked',
    target: :revoked_token,
    computed_details: lambda { |context|
      {
        datapass_id: context.revoked_token.authorization_request.external_id,
        blacklisted_at: context.revoked_token.blacklisted_at
      }
    },
    only_if: ->(context) { context.revoked_token.present? }

  organize SecurityEvent::Track
end
