class APIEntreprise::TokenMailerPreview < ActionMailer::Preview
  %w[
    expiration_notice_90J
    expiration_notice_60J
    expiration_notice_30J
    expiration_notice_15J
    expiration_notice_7J
    expiration_notice_0J
  ].each do |method|
    send('define_method', method) do
      APIEntreprise::TokenMailer.send(method, { to:, cc:, token: })
    end
  end

  def magic_link
    APIEntreprise::TokenMailer.magic_link(magic_link_record, host)
  end

  def banned
    APIEntreprise::TokenMailer.with(token: banned_token, recipients: [to], comment: 'Token was compromised due to suspicious activity').banned
  end

  def created
    APIEntreprise::TokenMailer.with(token:, actor: token.authorization_request.demandeur, recipients: [to]).created
  end

  def revoked
    APIEntreprise::TokenMailer.with(token:, actor: token.authorization_request.demandeur, recipients: [to]).revoked
  end

  private

  def to
    'example@fake.com'
  end

  def cc; end

  def token
    AuthorizationRequest.with_tokens_for('entreprise').first.token
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
    'http://entreprise.api.gouv.fr/'
  end
end
