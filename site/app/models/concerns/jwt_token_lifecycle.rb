module JwtTokenLifecycle
  extend ActiveSupport::Concern

  included do
    validates :exp, presence: true

    scope :unexpired, -> { where('exp > ?', Time.zone.now.to_i) }
    scope :not_blacklisted, -> { where('blacklisted_at > ?', Time.zone.now).or(where(blacklisted_at: nil)) }
    scope :active, -> { not_blacklisted.unexpired }
  end

  def rehash
    AccessToken.create(jwt_data)
  end

  def expired?
    exp < Time.zone.now.to_i
  end

  def blacklisted?
    blacklisted_at.present? && blacklisted_at < Time.zone.now
  end

  def active?
    !blacklisted? && !expired?
  end
end
