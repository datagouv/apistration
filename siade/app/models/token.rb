class Token < ApplicationRecord
  belongs_to :authorization_request, foreign_key: 'authorization_request_model_id', inverse_of: :tokens

  delegate :scopes, to: :authorization_request

  def siret
    authorization_request.try(:siret)
  end

  def blacklisted?
    blacklisted_at.present? &&
      blacklisted_at < Time.zone.now
  end

  def to_jwt_user_attributes
    {
      uid: id,
      jti: id,
      scopes:,
      iat:,
      exp:,
      siret:,
      blacklisted: blacklisted?
    }
  end
end
