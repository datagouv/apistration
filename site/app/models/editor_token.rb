class EditorToken < ApplicationRecord
  include JwtTokenLifecycle
  include AllowedIpsField

  belongs_to :editor

  attribute :iat, default: -> { Time.zone.now.to_i }
  attribute :exp, default: -> { 18.months.from_now.to_i }

  def ip_allowed?(request_ip)
    request_addr = parse_ip(request_ip)

    [allowed_ips, Array(editor&.allowed_ips)].all? do |entries|
      entries.empty? || (request_addr.present? && entries.any? { |entry| parse_ip(entry)&.include?(request_addr) })
    end
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

  def allowed_ips_envelope
    Array(editor&.allowed_ips)
  end

  def allowed_ips_envelope_error
    :outside_editor_range
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
