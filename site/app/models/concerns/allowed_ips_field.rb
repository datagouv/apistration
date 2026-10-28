module AllowedIpsField
  extend ActiveSupport::Concern

  included do
    validates :allowed_ips, allowed_ips: true, if: :allowed_ips_changed?
    validate :allowed_ips_within_envelope, if: :allowed_ips_changed?
  end

  def allowed_ips_as_strings
    allowed_ips.map { |ip| ip&.cidr }
  end

  def allowed_ips_text
    @allowed_ips_text || allowed_ips_as_strings.join("\n")
  end

  def allowed_ips_text=(value)
    @allowed_ips_text = value
    self.allowed_ips = value.to_s.split(/[\s,]+/).compact_blank
  end

  def allowed_ips=(value)
    previous_cidrs = allowed_ips_as_strings
    super
    allowed_ips_will_change! if allowed_ips_as_strings != previous_cidrs
  end

  private

  def allowed_ips_within_envelope
    return if errors[:allowed_ips].present?

    ranges = allowed_ips_envelope_ranges
    return if ranges.empty?

    allowed_ips.reject { |ip| ranges.any? { |range| range.include?(ip) } }
      .each { |ip| errors.add(:allowed_ips, allowed_ips_envelope_error, entry: ip.cidr) }
  end

  def allowed_ips_envelope_ranges
    allowed_ips_envelope.filter_map { |entry| parse_ip(entry) }
  end

  def parse_ip(entry)
    entry.is_a?(IPAddr) ? entry : IPAddr.new(entry.to_s)
  rescue IPAddr::Error
    nil
  end
end
