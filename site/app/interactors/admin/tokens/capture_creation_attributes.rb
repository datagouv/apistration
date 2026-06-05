class Admin::Tokens::CaptureCreationAttributes < ApplicationInteractor
  def call
    context.admin_after_attributes = {
      'exp' => context.token.exp,
      'scopes' => context.token.scopes
    }
  end
end
