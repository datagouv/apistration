class MagicLink::FindUsable < ApplicationInteractor
  def call
    context.magic_link = MagicLink.find_by(access_token: context.access_token)
    context.token = context.magic_link&.token

    context.fail!(message: unusable_reason) if unusable_reason
  end

  private

  def unusable_reason
    if context.magic_link.blank?
      'unknown'
    elsif context.magic_link.expired?
      'expired'
    elsif context.magic_link.token.nil?
      'missing'
    end
  end
end
