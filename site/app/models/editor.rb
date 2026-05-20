class Editor < ApplicationRecord
  ROLES = %w[manages_token client_manages_token legacy_token].freeze
  DEPLOYMENT_TYPES = %w[saas on_premise].freeze

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

  scope :delegable, -> { where(delegations_enabled: true) }
  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :with_role, ->(role) { where(role:) }
  scope :with_deployment_type, ->(type) { where(deployment_type: type) }
  scope :filtered, lambda { |params|
    scope = all
    scope = scope.search_by_name(params[:search]) if params[:search].present?
    scope = scope.with_role(params[:role]) if params[:role].present?
    scope = scope.with_deployment_type(params[:deployment_type]) if params[:deployment_type].present?
    scope
  }

  def authorization_requests(api:)
    AuthorizationRequest
      .where(api:)
      .where(demarche: form_uids)
  end

  def manages_token?
    role == 'manages_token'
  end

  def client_manages_token?
    role == 'client_manages_token'
  end

  def legacy_token?
    role == 'legacy_token'
  end

  def saas?
    deployment_type == 'saas'
  end

  def on_premise?
    deployment_type == 'on_premise'
  end
end
