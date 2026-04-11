class MaintenanceService
  attr_reader :provider

  def initialize(provider)
    @provider = provider
  end

  def on?
    provider_config.present? &&
      valid_date? &&
      maintenance_windows.any? { |maintenance_window| maintenance_window.cover?(now) }
  end

  def from_hour
    if specific_dates? && today_timeframe
      parse_hour(today_timeframe[:from_hour])
    else
      parse_hour(provider_config[:from_hour])
    end
  end

  def to_hour
    if specific_dates? && today_timeframe
      parse_hour(today_timeframe[:to_hour])
    else
      parse_hour(provider_config[:to_hour])
    end
  end

  def remaining_seconds
    return unless on?

    if from_hour > to_hour && now > from_hour
      (to_hour + 1.day - now).to_i
    else
      (to_hour - now).to_i
    end
  end

  def self.config
    @config ||= Rails.application.config_for(:maintenances)
  end

  private

  def valid_date?
    everyday? ||
      this_day? ||
      dates.any? { |date| date == today }
  end

  def everyday?
    !specific_dates? &&
      provider_config[:day].blank?
  end

  def this_day?
    provider_config[:day] == today.strftime('%A').downcase
  end

  def specific_dates?
    provider_config[:dates].present?
  end

  def dates
    (provider_config[:dates] || []).map do |date|
      Date.parse(date[:day])
    end
  end

  def today
    @today ||= Time.zone.today
  end

  def today_timeframe
    provider_config[:dates].find do |date|
      date[:day] == today.to_s
    end
  end

  def maintenance_windows
    if from_hour > to_hour
      [
        (from_hour..now.end_of_day),
        (now.beginning_of_day..to_hour)
      ]
    else
      [
        (from_hour..to_hour)
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
    self.class.config
  end
end
