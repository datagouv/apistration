class User::Login::ExtractProconnectIdentity < ApplicationInteractor
  def call
    context.user_params = context.omniauth_auth.info.slice('email', 'last_name', 'first_name', 'uid')
    context.idp = context.omniauth_auth.extra&.dig('raw_info', 'idp_id')
  end
end
