class User::Login::EnsureMfa < ApplicationInteractor
  def call
    return if OmniAuth::Strategies::Proconnect::MFA_ACR_VALUES.include?(acr)

    MonitoringService.instance.track(
      'OAuth security: Missing MFA',
      level: 'error',
      context: {
        provider: context.provider,
        acr:
      }
    )

    context.fail!(message: 'mfa_missing')
  end

  private

  def acr
    context.omniauth_auth.extra&.acr
  end
end
