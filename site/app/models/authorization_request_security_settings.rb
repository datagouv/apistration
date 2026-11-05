class AuthorizationRequestSecuritySettings < ApplicationRecord
  THROTTLE_OVERRIDE_KEYS = %w[limit period].freeze

  belongs_to :authorization_request

  validates :rate_limit_per_minute, numericality: { greater_than: 0 }, allow_nil: true
  validate :validate_allowed_ips_format
  validate :validate_throttle_overrides_format

  private

  def validate_throttle_overrides_format
    return if throttle_overrides.blank?

    throttle_overrides.each do |throttle_name, override|
      errors.add(:throttle_overrides, "#{throttle_name.inspect} is not a throttle of throttle.yml") unless ThrottleStore.throttle_names.include?(throttle_name)
      errors.add(:throttle_overrides, "#{throttle_name} must be { \"limit\" => Integer, \"period\" => Integer }, both positive") unless valid_throttle_override?(override)
    end
  end

  def valid_throttle_override?(override)
    override = Hash.try_convert(override)

    override&.keys&.sort == THROTTLE_OVERRIDE_KEYS && override.values.all? { |value| positive_integer?(value) }
  end

  def positive_integer?(value)
    coerced = Integer(value, exception: false)

    coerced.present? && coerced.eql?(value) && coerced.positive?
  end

  def validate_allowed_ips_format
    return if allowed_ips.blank?

    allowed_ips.each do |ip|
      IPAddr.new(ip)
    rescue IPAddr::InvalidAddressError
      errors.add(:allowed_ips, "contains invalid IP or CIDR: #{ip}")
    end
  end
end
