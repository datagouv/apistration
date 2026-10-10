class User::Login::ValidateOAuthProvider < ApplicationInteractor
  ALLOWED_OAUTH_PROVIDERS = %w[
    proconnect_api_entreprise
    proconnect_api_particulier
  ].freeze

  def call
    return if ALLOWED_OAUTH_PROVIDERS.include?(context.provider)

    MonitoringService.instance.track(
      'OAuth security: Invalid provider attempt',
      level: 'info',
      context: {
        provider: context.provider,
        ip: context.ip
      }
    )

    context.fail!(message: 'invalid_provider')
  end
end
