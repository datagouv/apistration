class Token::DeliverMagicLinkToEmail < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.shared',
    target: :token,
    computed_details: ->(context) { sharing_details(context.magic_link) },
    only_if: ->(context) { context.token.present? }

  organize ValidateEmail,
    Token::CreateMagicLink,
    Token::SendEmailWithMagicLink,
    SecurityEvent::Track

  def self.sharing_details(magic_link)
    recipient_domain = EmailDomain.new(magic_link.email)
    authorization_request = magic_link.token.authorization_request

    {
      recipient_email_domain: recipient_domain.name,
      recipient_webmail: recipient_domain.webmail?,
      recipient_outside_organization: recipient_domain.outside?(authorization_request.users.map(&:email)),
      expires_at: magic_link.expires_at,
      datapass_id: authorization_request.external_id
    }
  end
end
