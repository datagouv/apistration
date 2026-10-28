class Token::NotifyOtherContacts < ApplicationInteractor
  def call
    return if recipients.empty?

    mailer_klass.with(token: context.token, actor: context.user, recipients:).public_send(context.event).deliver_later
  end

  private

  def recipients
    @recipients ||= (context.token.authorization_request.users - [context.user]).map(&:email).compact_blank.uniq
  end

  def mailer_klass
    "API#{context.token.api.capitalize}::TokenMailer".constantize
  end
end
