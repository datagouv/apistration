class AuthorizationRequestSecuritySettings < ApplicationRecord
  belongs_to :authorization_request

  validates :rate_limit_per_minute, numericality: { greater_than: 0 }, allow_nil: true
  validate :validate_allowed_ips_format
  validate :validate_throttle_overrides_format

  private

  def validate_throttle_overrides_format
    return if throttle_overrides.blank?

    throttle_overrides.each do |throttle_name, limit|
      errors.add(:throttle_overrides, 'has a blank throttle name') if throttle_name.blank?

      coerced = Integer(limit, exception: false)
      next if coerced && coerced == limit && coerced.positive?

      errors.add(:throttle_overrides, "limit for #{throttle_name} must be a positive integer")
    end
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
