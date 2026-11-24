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

  normalizes :contact_email, with: ->(email) { email.strip.downcase.presence }

  attribute :terms_of_service_accepted, :boolean
  attribute :data_protection_officer_informed, :boolean

  generates_token_for :invitation

  validates :siret, format: { with: /\A\d{14}\z/ }, uniqueness: { scope: :editor_delegation_campaign_id }
  validates :authorization_request_id, uniqueness: true, allow_nil: true
  validates(*DATA_PROTECTION_OFFICER_ATTRIBUTES, presence: true, on: %i[data_protection_officer submission])
  validates :delegue_protection_donnees_email, format: { with: URI::MailTo::EMAIL_REGEXP }, on: %i[data_protection_officer submission]
  validates :terms_of_service_accepted, :data_protection_officer_informed, acceptance: { accept: true, allow_nil: false }, on: :submission
  validates :submitted_at, :submitted_by_user_id, presence: true, on: :submission

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

  def invited_on?(editor_slug:, api:)
    self.editor_slug == editor_slug && editor_delegation_campaign.api == api
  end

  def editor_slug
    editor.name.parameterize
  end

  def data_protection_officer_complete?
    DATA_PROTECTION_OFFICER_ATTRIBUTES.all? { |attribute| public_send(attribute).present? } &&
      URI::MailTo::EMAIL_REGEXP.match?(delegue_protection_donnees_email)
  end

  def submitted?
    submitted_at.present?
  end

  def transmitted_to_datapass?
    authorization_request&.first_submitted_at.present?
  end

  def refused_by_datapass!(reason)
    update!(submitted_at: nil, submitted_by_user: nil, datapass_error: reason)
  end
end
