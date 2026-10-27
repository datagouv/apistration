class Token::RetrieveExpiring < ApplicationInteractor
  def call
    expiration_period = expire_in.days.from_now.to_i

    context.expiring_tokens = Token
      .not_blacklisted
      .joins(:authorization_request)
      .merge(AuthorizationRequest.not_archived)
      .where(exp: 1.day.ago.to_i..expiration_period)
      .where('NOT EXISTS (SELECT 1 FROM jsonb_array_elements_text(tokens.days_left_notification_sent::jsonb) AS elem WHERE elem::integer <= ?)', expire_in)
  end

  private

  def expire_in
    context.expire_in
  end
end
