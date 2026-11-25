class Editor < ApplicationRecord
  APIS = %w[entreprise particulier].freeze
  ROLES = %w[manages_token client_manages_token both].freeze
  DEPLOYMENT_TYPES = %w[saas on_premise both other].freeze
  TWO_FACTOR_STATUSES = %w[yes in_progress no].freeze
  TWO_FACTOR_METHODS = %w[totp sms email_otp proconnect hardware_key other].freeze

  self.ignored_columns += %w[form_uids contact_email contact_phone]

  has_many :users,
    dependent: :nullify
  has_many :editor_delegations,
    dependent: :destroy
  has_many :tokens,
    class_name: 'EditorToken',
    dependent: :destroy
  has_many :contacts,
    class_name: 'EditorContact',
    dependent: :destroy
  has_many :use_cases,
    class_name: 'EditorUseCase',
    dependent: :destroy

  normalizes :deployment_type, :two_factor_status, :hosting_provider, :hosting_country, with: ->(value) { value.strip.presence }
  normalizes :two_factor_methods, with: ->(methods) { methods.compact_blank.uniq }
  normalizes :mon_service_securise_url, with: ->(url) { url.strip.presence }

  before_validation :clear_security_accreditation_dates, unless: :security_accreditation?

  validates :name, presence: true
  validates :apis, presence: true
  validates :siret, format: { with: /\A\d{14}\z/ }, allow_blank: true
  validates :role, inclusion: { in: ROLES }, allow_nil: true
  validates :deployment_type, inclusion: { in: DEPLOYMENT_TYPES }, allow_nil: true
  validates :allowed_ips, allowed_ips: true, if: :allowed_ips_changed?
  validates :two_factor_status, inclusion: { in: TWO_FACTOR_STATUSES }, allow_nil: true
  validates :two_factor_deadline, presence: true, if: :two_factor_in_progress?
  validates :security_accreditation_begin_date, :security_accreditation_end_date, presence: true, if: :security_accreditation?
  validates :security_accreditation_end_date, comparison: { greater_than: :security_accreditation_begin_date }, if: -> { security_accreditation_begin_date && security_accreditation_end_date }
  validate :mon_service_securise_url_is_a_web_address, if: :mon_service_securise_url
  validate :two_factor_methods_included_in_list
  validate :apis_included_in_list

  scope :delegable, -> { where(editor_tokens_enabled: true) }
  scope :for_api, ->(api) { where('ARRAY[:api]::varchar[] <@ apis', api:) }
  scope :for_demarche, ->(demarche) { where(id: EditorUseCase.where(form_uid: demarche).select(:editor_id)) }
  scope :search_by_name_or_siret, lambda { |query|
    where('name ILIKE :q OR siret ILIKE :q', q: "%#{query}%")
  }
  scope :filtered, lambda { |params|
    params[:search].present? ? search_by_name_or_siret(params[:search]) : all
  }

  def self.role_options
    [[I18n.t('editors.roles.blank'), '']] +
      ROLES.map { |role| [I18n.t(role, scope: 'editors.roles'), role] }
  end

  def self.deployment_type_options
    [[I18n.t('editors.deployment_types.blank'), '']] +
      DEPLOYMENT_TYPES.map { |type| [I18n.t(type, scope: 'editors.deployment_types'), type] }
  end

  def authorization_requests(api:)
    AuthorizationRequest
      .where(api:)
      .where(demarche: use_cases.with_form.select(:form_uid))
  end

  def form_uids
    use_cases.with_form.order(:form_uid).pluck(:form_uid)
  end

  def organization
    Organization.find_by(siret:) if siret.present?
  end

  def serves_api?(api)
    apis.include?(api.to_s)
  end

  def manages_token?
    role == 'manages_token'
  end

  def client_manages_token?
    role == 'client_manages_token'
  end

  def both_roles?
    role == 'both'
  end

  def two_factor_in_progress?
    two_factor_status == 'in_progress'
  end

  def security_contacts
    contacts.select { |contact| contact.role == 'security' }
  end

  def saas?
    deployment_type == 'saas'
  end

  def on_premise?
    deployment_type == 'on_premise'
  end

  def both_deployments?
    deployment_type == 'both'
  end

  def other_deployment?
    deployment_type == 'other'
  end

  private

  def mon_service_securise_url_is_a_web_address
    uri = URI.parse(mon_service_securise_url)
    errors.add(:mon_service_securise_url, :invalid) unless %w[http https].include?(uri.scheme) && uri.host.present?
  rescue URI::InvalidURIError
    errors.add(:mon_service_securise_url, :invalid)
  end

  def clear_security_accreditation_dates
    self.security_accreditation_begin_date = nil
    self.security_accreditation_end_date = nil
  end

  def two_factor_methods_included_in_list
    errors.add(:two_factor_methods, :inclusion) unless (two_factor_methods - TWO_FACTOR_METHODS).empty?
  end

  def apis_included_in_list
    return if apis.all? { |api| APIS.include?(api) }

    errors.add(:apis, :inclusion)
  end
end
