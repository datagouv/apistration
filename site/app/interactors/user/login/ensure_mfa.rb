class User::Login::EnsureMfa < ApplicationInteractor
  def call
    context.acr = acr
    context.mfa = OmniAuth::Strategies::Proconnect::MFA_ACR_VALUES.include?(acr)
    return if context.mfa

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
