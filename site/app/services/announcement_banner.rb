require 'singleton'

class AnnouncementBanner
  include Singleton

  def active?
    return false unless start_time && end_time

    Time.zone.now.between?(start_time, end_time)
  end

  def title = config[:title]
  def description = config[:description]

  def start_time = parse(config[:start])
  def end_time = parse(config[:end])

  private

  def parse(value)
    return nil if value.blank?

    Time.use_zone(Time.zone) do
      parsed = Chronic.parse(value.to_s) or return nil
      Time.zone.local(parsed.year, parsed.month, parsed.day, parsed.hour, parsed.min, parsed.sec)
    end
  end

  def config
    @config ||= Rails.application.config_for(:announcement_banner)
  end
end
