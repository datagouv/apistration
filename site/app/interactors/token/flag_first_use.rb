class Token::FlagFirstUse < ApplicationInteractor
  delegate :token, to: :context

  def call
    context.first_used_at = token.access_logs.where(timestamp: token.created_at..).minimum(:timestamp)
    return if context.first_used_at.nil?

    context.token_flagged = flag_token_as_used
  end

  private

  def flag_token_as_used
    token.with_lock do
      next false if token.used

      token.update!(used: true)
    end
  end
end
