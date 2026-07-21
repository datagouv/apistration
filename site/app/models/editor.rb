class Editor < ApplicationRecord
  APIS = %w[entreprise particulier].freeze
  ROLES = %w[manages_token client_manages_token both].freeze
  DEPLOYMENT_TYPES = %w[saas on_premise both other].freeze

  has_many :users,
    dependent: :nullify
  has_many :editor_delegations,
    dependent: :destroy
  has_many :tokens,
    class_name: 'EditorToken',
    dependent: :destroy

  validates :name, presence: true
  validates :siret, format: { with: /\A\d{14}\z/ }, allow_blank: true
  validates :role, inclusion: { in: ROLES }, allow_nil: true
  validates :deployment_type, inclusion: { in: DEPLOYMENT_TYPES }, allow_nil: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :apis_included_in_list

  scope :delegable, -> { where(delegations_enabled: true) }
  scope :for_api, ->(api) { where('ARRAY[:api]::varchar[] <@ apis', api:) }
  scope :for_demarche, ->(demarche) { where(':demarche = ANY(form_uids)', demarche:) }
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
      .where(demarche: form_uids)
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

  def apis_included_in_list
    return if apis.all? { |api| APIS.include?(api) }

    errors.add(:apis, :inclusion)
  end
end
