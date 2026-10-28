module TokenMailersCommons
  extend ActiveSupport::Concern

  included { before_action :attach_logos }

  include FriendlyDateHelper
  include Rails.application.routes.url_helpers

  def expiration_notice
    assign_expiring_token(params[:token])
    @expired = params[:days].zero?

    mail(
      to: @authorization_request.users.map(&:email).compact_blank.uniq,
      subject: t("mailers.token_mailer.expiration_notice.subject_#{params[:days]}", name: @token.name, external_id: @authorization_request.external_id)
    )
  end

  def magic_link(magic_link, host)
    @magic_link = magic_link
    @host = host

    to = magic_link.email
    subject = t('mailers.token_mailer.magic_link.subject', api_name: api_full_name)

    mail(to:, subject:)
  end

  def banned
    @token = params[:token]
    @authorization_request = @token.authorization_request
    @comment = params[:comment]
    @intitule = @authorization_request.intitule
    @blacklisted_at = Time.at(@token.blacklisted_at).in_time_zone.strftime('%d/%m/%Y')

    mail(to: params[:recipients], subject: t('mailers.token_mailer.banned.subject', api_name: api_full_name))
  end

  def created
    contact_token_email(:created)
  end

  def revoked
    contact_token_email(:revoked)
  end

  private

  def assign_expiring_token(token)
    @token = token
    @authorization_request = token.authorization_request
    @authorization_request_url = authorization_request_url(id: @authorization_request.id)
    @expiration_date = Time.at(token.exp).in_time_zone.strftime('%d/%m/%Y')
  end

  def contact_token_email(event)
    @token = params[:token]
    @actor = params[:actor]
    @authorization_request = @token.authorization_request

    mail(
      to: params[:recipients],
      subject: t("mailers.token_mailer.#{event}.subject", name: @token.name, external_id: @authorization_request.external_id)
    )
  end
end
