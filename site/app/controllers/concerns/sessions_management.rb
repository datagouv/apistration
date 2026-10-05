module SessionsManagement # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern

  ALLOWED_OAUTH_PROVIDERS = %w[
    proconnect_api_entreprise
    proconnect_api_particulier
  ].freeze

  BYPASS_LOGIN_ENVIRONMENTS = %w[development staging sandbox].freeze

  included do
    before_action :validate_oauth_callback!, only: [:create_from_oauth]
  end

  def new
    redirect_current_user_to_homepage if user_signed_in?
  end

  def create_from_oauth
    return reject_login_without_mfa unless mfa_performed?

    interactor_call = User::ProconnectLogin.call(user_params:)

    login(interactor_call)
  end

  def failure
    error_message(title: t(".#{failure_message}", default: t('.unknown')))

    redirect_to login_path
  end

  def destroy
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

    user = User.find_by(email: params[:email]&.downcase)

    if user
      sign_in_and_redirect(user)
    else
      error_message(title: 'Compte introuvable')
      redirect_to root_path
    end
  end

  private

  def after_logout_path
    "/auth/proconnect_#{namespace}/logout"
  end

  def validate_oauth_callback!
    unless ALLOWED_OAUTH_PROVIDERS.include?(params[:provider])
      track_invalid_provider_attempt
      redirect_to(login_path) and return
    end

    return if request.env['omniauth.auth']

    track_missing_omniauth_data
    redirect_to(login_path) and return
  end

  def track_invalid_provider_attempt
    MonitoringService.instance.track(
      'OAuth security: Invalid provider attempt',
      level: 'info',
      context: {
        provider: params[:provider],
        ip: request.remote_ip
      }
    )
  end

  def track_missing_omniauth_data
    MonitoringService.instance.track(
      'OAuth security: Missing OmniAuth data',
      level: 'info',
      context: {
        provider: params[:provider],
        ip: request.remote_ip
      }
    )
  end

  def mfa_performed?
    OmniAuth::Strategies::Proconnect::MFA_ACR_VALUES.include?(oauth_acr)
  end

  def oauth_acr
    request.env['omniauth.auth'].extra&.acr
  end

  def reject_login_without_mfa
    MonitoringService.instance.track(
      'OAuth security: Missing MFA',
      level: 'error',
      context: {
        provider: params[:provider],
        acr: oauth_acr
      }
    )

    error_message(title: t('concerns.sessions_management.mfa_required'))
    redirect_to login_path
  end

  def user_params
    request.env['omniauth.auth'].info.slice('email', 'last_name', 'first_name', 'uid')
  end

  def login(interactor_call)
    if interactor_call.success?
      sign_in_and_redirect(interactor_call.user)
    else
      send(extract_flash_kind(interactor_call.message), title: t(".#{interactor_call.message}.title"), description: t(".#{interactor_call.message}.description", email: oauth_email))

      redirect_to login_path
    end
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
