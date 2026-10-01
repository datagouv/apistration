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

  belongs_to :editor_delegation_campaign
  belongs_to :authorization_request,
    optional: true
  belongs_to :submitted_by_user,
    class_name: 'User',
    optional: true

  delegate :editor, to: :editor_delegation_campaign

  store_accessor :data, *DATA_PROTECTION_OFFICER_ATTRIBUTES

  attribute :terms_of_service_accepted, :boolean
  attribute :data_protection_officer_informed, :boolean

  generates_token_for :invitation

  validates :siret, format: { with: /\A\d{14}\z/ }, uniqueness: { scope: :editor_delegation_campaign_id }
  validates :authorization_request_id, uniqueness: true, allow_nil: true
  validates(*DATA_PROTECTION_OFFICER_ATTRIBUTES, presence: true, on: %i[data_protection_officer submission])
  validates :delegue_protection_donnees_email, format: { with: URI::MailTo::EMAIL_REGEXP }, on: %i[data_protection_officer submission]
  validates :terms_of_service_accepted, :data_protection_officer_informed, acceptance: { accept: true, allow_nil: false }, on: :submission
  validates :submitted_at, :submitted_by_user, presence: true, on: :submission

  DATA_PROTECTION_OFFICER_ATTRIBUTES.each do |attribute|
    define_method(:"#{attribute}=") do |value|
      value = value&.strip
      value = value&.downcase if DOWNCASED_ATTRIBUTES.include?(attribute)

      super(value)
    end
  end

  def datapass_data
    editor_delegation_campaign.datapass_data.merge(data)
  end

  def invitation_path
    Rails.application.routes.url_helpers.editor_delegation_request_path(editor_slug:, token: generate_token_for(:invitation))
  end

  def editor_slug
    editor.name.parameterize
  end

  def other_pending_requests_of_contact
    return EditorDelegationRequest.none if contact_email.blank?

    EditorDelegationRequest
      .where(contact_email:, submitted_at: nil)
      .where.not(id:)
      .includes(editor_delegation_campaign: :editor)
      .order(:siret)
  end

  def submitted?
    submitted_at.present?
  end
end
