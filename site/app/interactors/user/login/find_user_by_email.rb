class User::Login::FindUserByEmail < ApplicationInteractor
  def call
    context.user = User.find_by(email: context.email&.downcase)

    context.fail!(message: 'unknown_user') if context.user.nil?
  end
end
