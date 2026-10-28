class Token::TrackScopesChange < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.scopes_changed',
    target: :prolonged_token,
    computed_details: ->(context) { scopes_change(context.prolonged_token) },
    only_if: ->(context) { scopes_changed?(context.prolonged_token) }

  organize SecurityEvent::Track

  def self.scopes_changed?(token)
    return false if token.nil?

    previous_scopes, scopes = token.saved_change_to_scopes
    Array(previous_scopes).sort != Array(scopes).sort
  end

  def self.scopes_change(token)
    previous_scopes, scopes = token.saved_change_to_scopes

    {
      datapass_id: token.authorization_request.external_id,
      previous_scopes:,
      scopes:,
      added_scopes: scopes - previous_scopes,
      removed_scopes: previous_scopes - scopes
    }
  end
end
