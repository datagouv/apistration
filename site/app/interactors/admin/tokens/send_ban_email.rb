class Admin::Tokens::SendBanEmail < ApplicationInteractor
  def call
    return if recipients.empty?

    mailer.with(token:, recipients:, comment: context.comment).banned.deliver_later
  end

  private

  def recipients
    @recipients ||= token.authorization_request.users.map(&:email).compact_blank.uniq
  end

  def token = context.token

  def mailer
    "api_#{context.namespace}".camelize.constantize::TokenMailer
  end
end
