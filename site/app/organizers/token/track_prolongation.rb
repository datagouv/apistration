class Token::TrackProlongation < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.prolonged',
    target: :prolonged_token,
    computed_details: ->(context) { prolongation_details(context) },
    only_if: ->(context) { context.token_prolonged }

  organize SecurityEvent::Track

  def self.prolongation_details(context)
    token = context.prolonged_token

    {
      source: context.token_prolongation_source,
      datapass_id: token.authorization_request.external_id,
      expires_at: Time.zone.at(token.exp)
    }
  end
end
