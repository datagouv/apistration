class Admin::Tokens::CaptureBanAttributes < ApplicationInteractor
  def call
    context.admin_before_attributes = { 'blacklisted_at' => nil }
    context.admin_after_attributes = {
      'blacklisted_at' => context.token.blacklisted_at,
      'comment' => context.comment,
      'generate_new_token' => context.generate_new_token != false,
      'new_token_id' => context.new_token&.id
    }
  end
end
