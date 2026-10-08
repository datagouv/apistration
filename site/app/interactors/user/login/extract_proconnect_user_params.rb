class User::Login::ExtractProconnectUserParams < ApplicationInteractor
  def call
    context.user_params = context.omniauth_auth.info.slice('email', 'last_name', 'first_name', 'uid')
  end
end
