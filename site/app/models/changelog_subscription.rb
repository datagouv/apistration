class ChangelogSubscription < ApplicationRecord
  SCOPES = %w[api_entreprise api_particulier].freeze

  belongs_to :user

  before_validation :ensure_unsubscribe_token, on: :create

  validates :scope, presence: true, inclusion: { in: SCOPES }
  validates :user_id, uniqueness: { scope: :scope, conditions: -> { active } }
  validates :unsubscribe_token, presence: true, uniqueness: true

  scope :active, -> { where(disabled_at: nil) }
  scope :disabled, -> { where.not(disabled_at: nil) }
  scope :for_scope, ->(scope) { where(scope: scope.to_s) }

  def active?
    disabled_at.nil?
  end

  def disable!
    return if disabled_at.present?

    update!(disabled_at: Time.current)
  end

  def covers?(entry_scope)
    entry_scope == scope || entry_scope == 'both'
  end

  private

  def ensure_unsubscribe_token
    return if unsubscribe_token.present?

    loop do
      candidate = SecureRandom.urlsafe_base64(32)
      next if self.class.exists?(unsubscribe_token: candidate)

      self.unsubscribe_token = candidate
      break
    end
  end
end
