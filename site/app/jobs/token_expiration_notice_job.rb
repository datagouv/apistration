class TokenExpirationNoticeJob < ApplicationJob
  queue_as :default

  def perform
    number_of_days_before_expiration.each do |number_of_days|
      token_expiration_notice(number_of_days)
    end
  end

  private

  def token_expiration_notice(number_of_days)
    Token::SendExpirationNotices.call(expire_in: number_of_days)
  end

  def number_of_days_before_expiration
    ScheduleExpirationNoticeEmailJob::NOTICE_DAYS
  end
end
