class Token < ApplicationRecord
  belongs_to :authorization_request, foreign_key: 'authorization_request_model_id', inverse_of: :tokens

  def siret
    authorization_request.try(:siret)
  end

  def blacklisted?
    blacklisted_at.present? &&
      blacklisted_at < Time.zone.now
  end

  def legacy_token?
    extra_info.present? && extra_info['legacy_token_id'].present?
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
