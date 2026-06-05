class AdminActivity < ApplicationRecord
  NAMES = %w[
    impersonation_started
    impersonation_stopped
    token_banned
    token_created
    editor_token_created
    user_updated
    editor_updated
    audit_notification_created
  ].freeze

  belongs_to :admin, class_name: 'User'
  belongs_to :entity, polymorphic: true, optional: true

  validates :name, :namespace, presence: true

  scope :recent, -> { reorder(created_at: :desc) }

  def self.ransackable_attributes(_ = nil)
    %w[name entity_type created_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[admin]
  end
end
