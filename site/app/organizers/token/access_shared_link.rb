class Token::AccessSharedLink < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.shared_link_accessed',
    target: :token,
    computed_details: ->(context) { shared_link_details(context.magic_link) }

  tracks_security_event_failures

  organize MagicLink::FindUsable,
    SecurityEvent::Track

  def self.shared_link_details(magic_link)
    return {} if magic_link.nil?

    {
      datapass_id: magic_link.token&.authorization_request&.external_id,
      expires_at: magic_link.expires_at
    }
  end
end
