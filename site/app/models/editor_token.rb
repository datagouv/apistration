class EditorToken < ApplicationRecord
  include JwtTokenLifecycle

  belongs_to :editor

  validates :allowed_ips, allowed_ips: true

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
