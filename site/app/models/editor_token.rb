class EditorToken < ApplicationRecord
  include JwtTokenLifecycle

  belongs_to :editor

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
