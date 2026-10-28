class APIParticulier::TokenMailerPreview < ActionMailer::Preview
  [30, 7, 0].each do |days|
    define_method("expiration_notice_#{days}_days") do
      APIParticulier::TokenMailer.with(token:, days:).expiration_notice
    end
  end

  def magic_link
    APIParticulier::TokenMailer.magic_link(magic_link_record, host)
  end

  def banned
    APIParticulier::TokenMailer.with(token: banned_token, recipients: [to], comment: 'Token was compromised due to suspicious activity').banned
  end

  def created
    APIParticulier::TokenMailer.with(token:, actor: token.authorization_request.demandeur, recipients: [to]).created
  end

  def extended
    APIParticulier::TokenMailer.with(token:, actor: token.authorization_request.demandeur, recipients: [to]).extended
  end

  def revoked
    APIParticulier::TokenMailer.with(token:, actor: token.authorization_request.demandeur, recipients: [to]).revoked
  end

  private

  def to
    'example@fake.com'
  end

  def cc; end

  def token
    AuthorizationRequest.with_tokens_for('particulier').first.token
  end

  def banned_token
    old_token = token.dup
    old_token.blacklisted_at = 1.month.from_now
    old_token
  end

  def magic_link_record
    MagicLink.first
  end

  def host
    'http://particulier.api.gouv.fr/'
  end
end
