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
    extra_info['legacy_token_id'].present?
  end

  def legacy_token_migrated?
    legacy_token? && (extra_info['legacy_token_migrated'].try(:to_s) == 'true')
  end
end
