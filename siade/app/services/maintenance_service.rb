class MaintenanceService
  attr_reader :provider

  def initialize(provider)
    @provider = provider
  end

  def on?
    provider_config.present? &&
      maintenance_windows.any? { |maintenance_window| maintenance_window.cover?(now) }
  end

  def from_hour
    parse_hour(provider_config[:from_hour])
  end

  def to_hour
    parse_hour(provider_config[:to_hour])
  end

  def end_in
    return unless on?

    if from_hour > to_hour && now > from_hour
      (to_hour + 1.day - now).to_i
    else
      (to_hour - now).to_i
    end
  end

  private

  def maintenance_windows
    if from_hour > to_hour
      [
        (from_hour..now.end_of_day),
        (now.beginning_of_day..to_hour),
      ]
    else
      [
        (from_hour..to_hour),
      ]
    end
  end

  def parse_hour(hour)
    Time.zone.parse(hour)
  end

  def now
    @now ||= Time.zone.now
  end

  def provider_config
    @provider_config ||= config[provider]
  end

  def config
    Rails.application.config_for(:maintenances)
  end
end
