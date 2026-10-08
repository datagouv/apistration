class User::Login::ValidateOmniauthData < ApplicationInteractor
  def call
    return if context.omniauth_auth

    MonitoringService.instance.track(
      'OAuth security: Missing OmniAuth data',
      level: 'info',
      context: {
        provider: context.provider,
        ip: context.ip
      }
    )

    context.fail!(message: 'missing_omniauth_data')
  end
end
