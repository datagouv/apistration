class EditorToken < ApplicationRecord
  include JwtTokenLifecycle

  belongs_to :editor

  validates :allowed_ips, allowed_ips: true

  def allowed_ips_as_strings
    allowed_ips.map { |ip| "#{ip}/#{ip.prefix}" }
  end

  def revoke!
    update!(blacklisted_at: Time.zone.now)
  end

  def rotate!
    transaction do
      revoke!

      editor.tokens.create!(
        iat: Time.zone.now.to_i,
        exp: 18.months.from_now.to_i,
        allowed_ips: allowed_ips
      )
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
