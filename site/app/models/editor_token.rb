class EditorToken < ApplicationRecord
  include JwtTokenLifecycle

  belongs_to :editor

  attribute :iat, default: -> { Time.zone.now.to_i }
  attribute :exp, default: -> { 18.months.from_now.to_i }

  validates :allowed_ips, allowed_ips: true

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

  def rotate!
    transaction do
      revoke!

      editor.tokens.create!(allowed_ips: allowed_ips)
    end
  end

  private

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
