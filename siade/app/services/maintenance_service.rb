class MaintenanceService
  attr_reader :provider

  def initialize(provider)
    @provider = provider
  end

  def on?
    provider_config.present? &&
      maintenance_window.cover?(now)
  end

  private

  def maintenance_window
    (Time.zone.parse(provider_config[:from_hour])..Time.zone.parse(provider_config[:to_hour]))
  end

  def now
    @now ||= Time.zone.now
  end

  def provider_config
    @provider_config ||= config[provider.to_sym]
  end

  def config
    Rails.application.config_for(:maintenances)
  end
end
