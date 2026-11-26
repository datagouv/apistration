class EditorContact < ApplicationRecord
  ROLES = %w[technical business dpo security].freeze
  EDITABLE_ATTRIBUTES = %i[role full_name email phone].freeze

  belongs_to :editor

  normalizes :full_name, with: ->(name) { anonymized_in_staging(:last_name, name) }
  normalizes :email, with: ->(email) { anonymized_in_staging(:email, email) }
  normalizes :phone, with: ->(phone) { anonymized_in_staging(:phone, phone) }

  validates :role, inclusion: { in: ROLES }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validate :email_or_phone_present

  scope :by_role, -> { in_order_of(:role, ROLES).order(:created_at) }

  def self.anonymized_in_staging(kind, value)
    value = value.strip.presence
    Rails.env.staging? ? PersonalDataAnonymizer.public_send(kind, value) : value
  end

  def self.role_options
    ROLES.map { |role| [I18n.t(role, scope: 'editor_contacts.roles'), role] }
  end

  def role_label
    I18n.t(role, scope: 'editor_contacts.roles')
  end

  private

  def email_or_phone_present
    errors.add(:base, :email_or_phone_missing) if email.blank? && phone.blank?
  end
end
