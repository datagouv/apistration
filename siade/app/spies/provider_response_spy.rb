class ProviderResponseSpy
  def self.log_http_code(provider_name:, http_code:)
    ActiveSupport::Notifications.instrument('provider_http_code', provider_name: provider_name, http_code: http_code)
  end
end
