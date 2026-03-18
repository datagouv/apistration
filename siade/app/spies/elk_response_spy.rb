class ELKResponseSpy
  def self.log_fallback_usage(provider_name:, fallback_used:)
    ActiveSupport::Notifications.instrument('response', provider_name: provider_name, fallback_used: fallback_used)
  end
end