class Token::DeliverExpirationNoticeEmails < ApplicationInteractor
  def call
    context.expiring_tokens.each do |token|
      token.with_lock do
        next unless still_due?(token)

        token.days_left_notification_sent << expire_in
        token.save!
        ScheduleExpirationNoticeEmailJob.perform_later(token, expire_in)
      end
    end
  end

  private

  def still_due?(token)
    !token.blacklisted? &&
      token.exp <= expire_in.days.from_now.to_i &&
      token.days_left_notification_sent.none? { |days| days.to_i <= expire_in }
  end

  def expire_in
    context.expire_in
  end
end
