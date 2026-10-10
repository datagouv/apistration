module SessionsManagement
  extend ActiveSupport::Concern

  BYPASS_LOGIN_ENVIRONMENTS = %w[development staging sandbox].freeze

  def new
    redirect_current_user_to_homepage if user_signed_in?
  end

  def create_from_oauth
    sign_in = User::ProconnectSignIn.call(
      provider: params[:provider],
      omniauth_auth: request.env['omniauth.auth'],
      ip: request.remote_ip
    )

    if sign_in.success?
      sign_in_and_redirect(sign_in.user)
    else
      reject_oauth_sign_in(sign_in)
    end
  end

  def failure
    error_message(title: t(".#{failure_message}", default: t('.unknown')))

    redirect_to login_path
  end

  def destroy
    User::CloseSession.call(user: current_user, reason: 'logout') if user_signed_in?
    logout_user

    redirect_to after_logout_path,
      allow_other_host: true
  end

  def after_logout
    success_message(title: t('.success'))

    redirect_to root_path
  end

  def dev_login
    unless BYPASS_LOGIN_ENVIRONMENTS.include?(Rails.env.to_s)
      redirect_to root_path
      return
    end

    sign_in = User::DevSignIn.call(email: params[:email])

    if sign_in.success?
      sign_in_and_redirect(sign_in.user)
    else
      error_message(title: 'Compte introuvable')
      redirect_to root_path
    end
  end

  private

  def after_logout_path
    "/auth/proconnect_#{namespace}/logout"
  end

  def reject_oauth_sign_in(sign_in)
    case sign_in.message
    when 'invalid_provider', 'missing_omniauth_data'
      redirect_to login_path
    when 'mfa_missing'
      error_message(title: t('concerns.sessions_management.mfa_required'))
      redirect_to login_path
    else
      reject_proconnect_login(sign_in)
    end
  end

  def reject_proconnect_login(sign_in)
    send(
      extract_flash_kind(sign_in.message),
      title: t(".#{sign_in.message}.title"),
      description: t(".#{sign_in.message}.description", email: sign_in.user_params['email'])
    )

    redirect_to login_path
  end

  def failure_message
    params[:message]
  end

  def extract_flash_kind(message)
    case message
    when 'not_found'
      'info_message'
    else
      'error_message'
    end
  end
end
