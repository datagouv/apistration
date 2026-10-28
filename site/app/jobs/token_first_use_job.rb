class TokenFirstUseJob < ApplicationJob
  ELIGIBILITY_AFTER_EXPIRATION = 30.days

  queue_as :default

  def perform
    Token.where(used: false).where(exp: ELIGIBILITY_AFTER_EXPIRATION.ago.to_i..).called.find_each do |token|
      Token::RecordFirstUse.call(token:)
    end
  end
end
