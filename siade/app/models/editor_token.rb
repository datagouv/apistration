class EditorToken < ApplicationRecord
  belongs_to :editor

  def blacklisted?
    blacklisted_at.present? && blacklisted_at < Time.zone.now
  end

  def to_jwt_user_attributes
    {
      uid: id,
      jti: id,
      scopes: [],
      iat:,
      exp:,
      blacklisted: blacklisted?,
      editor_id:
    }
  end
end
