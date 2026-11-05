class GiveThrottleOverridesTheirOwnPeriod < ActiveRecord::Migration[8.1]
  class SecuritySettings < ActiveRecord::Base
    self.table_name = 'authorization_request_security_settings'
  end

  def up
    convert_overrides do |throttle_name, limit|
      period = ThrottleStore.period_for_throttle(throttle_name)
      next limit if period.nil? || Hash.try_convert(limit)

      { 'limit' => limit, 'period' => period }
    end
  end

  def down
    convert_overrides do |_throttle_name, override|
      Hash.try_convert(override)&.fetch('limit') || override
    end
  end

  private

  def convert_overrides(&)
    SecuritySettings.where.not(throttle_overrides: {}).find_each do |settings|
      settings.update!(throttle_overrides: settings.throttle_overrides.to_h { |throttle_name, override| [throttle_name, yield(throttle_name, override)] })
    end
  end
end
