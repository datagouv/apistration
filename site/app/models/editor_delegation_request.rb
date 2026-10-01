class EditorDelegationRequest < ApplicationRecord
  DATA_PROTECTION_OFFICER_ATTRIBUTES = %w[
    delegue_protection_donnees_given_name
    delegue_protection_donnees_family_name
    delegue_protection_donnees_email
    delegue_protection_donnees_phone_number
    delegue_protection_donnees_job_title
  ].freeze

  DOWNCASED_ATTRIBUTES = %w[
    delegue_protection_donnees_email
    delegue_protection_donnees_phone_number
  ].freeze

  belongs_to :editor_use_case
  belongs_to :authorization_request,
    optional: true
  belongs_to :submitted_by_user,
    class_name: 'User',
    optional: true

  delegate :editor, to: :editor_use_case

  store_accessor :data, *DATA_PROTECTION_OFFICER_ATTRIBUTES

  generates_token_for :invitation

  validates :siret, format: { with: /\A\d{14}\z/ }, uniqueness: { scope: :editor_use_case_id }
  validates :authorization_request_id, uniqueness: true, allow_nil: true
  validates(*DATA_PROTECTION_OFFICER_ATTRIBUTES, presence: true, on: :data_protection_officer)
  validates :delegue_protection_donnees_email, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :data_protection_officer

  DATA_PROTECTION_OFFICER_ATTRIBUTES.each do |attribute|
    define_method(:"#{attribute}=") do |value|
      value = value&.strip
      value = value&.downcase if DOWNCASED_ATTRIBUTES.include?(attribute)

      super(value)
    end
  end

  def datapass_data
    editor_use_case.datapass_data.merge(data)
  end

  def submitted?
    submitted_at.present?
  end
end
