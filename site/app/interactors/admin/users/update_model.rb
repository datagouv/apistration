class Admin::Users::UpdateModel < ApplicationInteractor
  def call
    context.fail! unless context.user.update(context.user_params)
  end
end
