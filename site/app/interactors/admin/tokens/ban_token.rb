class Admin::Tokens::BanToken < ApplicationInteractor
  def call
    fail!('Token does not exist', :warning) if token.blank?

    token.with_lock do
      fail!('Token already blacklisted', :warning) if token.blacklisted?

      ban!
    end
  end

  private

  def ban!
    context.blacklisted_at = ban_date
    token.update!(blacklisted_at: context.blacklisted_at)
    context.token_banned = token.saved_change_to_blacklisted_at?
  end

  def ban_date
    [token.blacklisted_at, context.blacklisted_at || 1.month.from_now].compact.min
  end

  def token
    context.token
  end
end
