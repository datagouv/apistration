class EditorToken < ApplicationRecord
  include JwtTokenLifecycle

  belongs_to :editor

  attribute :iat, default: -> { Time.zone.now.to_i }
  attribute :exp, default: -> { 18.months.from_now.to_i }

  validates :allowed_ips, allowed_ips: true, if: :allowed_ips_changed?
  validate :allowed_ips_within_editor_range, if: :allowed_ips_changed?

  def allowed_ips_as_strings
    allowed_ips.map { |ip| "#{ip}/#{ip.prefix}" }
  end

  def allowed_ips_text
    @allowed_ips_text || allowed_ips_as_strings.join("\n")
  end

  def allowed_ips_text=(value)
    @allowed_ips_text = value
    self.allowed_ips = value.to_s.split(/[\s,]+/).compact_blank
  end

  def revoke!
    update!(blacklisted_at: Time.zone.now)
  end

  def rotate
    replacement = editor.tokens.new(allowed_ips: allowed_ips)
    return replacement unless replacement.valid?

    transaction do
      revoke!

      replacement.save!
    end

    replacement
  end

  def prolong!
    update!(exp: 18.months.from_now.to_i)
  end

  private

  def allowed_ips_within_editor_range
    return if errors[:allowed_ips].present?

    ranges = editor_ip_ranges
    return if ranges.empty?

    allowed_ips.reject { |token_ip| ranges.any? { |range| range.include?(token_ip) } }
      .each { |token_ip| errors.add(:allowed_ips, :outside_editor_range, entry: "#{token_ip}/#{token_ip.prefix}") }
  end

  def editor_ip_ranges
    return [] if editor.nil? || editor.allowed_ips.blank?

    editor.allowed_ips.filter_map { |entry| parse_ip(entry) }
  end

  def parse_ip(entry)
    entry.is_a?(IPAddr) ? entry : IPAddr.new(entry.to_s)
  rescue IPAddr::Error
    nil
  end

  def jwt_data
    {
      uid: id,
      jti: id,
      sub: editor.name,
      scopes: [],
      version: '1.0',
      iat: iat,
      exp: exp,
      editor: true
    }
  end
end
