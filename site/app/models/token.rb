class Token < ApplicationRecord
  include JwtTokenLifecycle
  include AllowedIpsField

  LIFETIMES_IN_MONTHS = [3, 6, 12, 18].freeze
  NAME_MAX_LENGTH = 50

  self.ignored_columns += %w[authorization_request_id]

  belongs_to :authorization_request, foreign_key: 'authorization_request_model_id', inverse_of: :tokens
  belongs_to :creator, class_name: 'User', optional: true

  scope :issued_in_last_seven_days, -> { where(created_at: 3.weeks.ago..1.week.ago) }
  scope :expired, -> { where(exp: ...Time.zone.now.to_i) }

  scope :blacklisted, -> { where(blacklisted_at: ...Time.zone.now) }
  scope :blacklisted_later, -> { where('blacklisted_at > ?', Time.zone.now) }

  scope :inactive, -> { blacklisted.or(expired) }
  scope :active_for, ->(api) { distinct.active.joins(:authorization_request).where(authorization_request: { api: }).reorder(created_at: :desc) }

  has_many :users, through: :authorization_request
  has_many :contacts, through: :authorization_request
  has_many :demandeurs, through: :authorization_request
  has_many :access_logs, inverse_of: :token, dependent: nil
  has_many :magic_links, inverse_of: :token, dependent: :destroy

  has_one :demandeur, through: :authorization_request
  delegate :contacts_no_demandeur, :archived?, to: :authorization_request

  attribute :lifetime_in_months, :integer, default: -> { LIFETIMES_IN_MONTHS.max }

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :lifetime_in_months, inclusion: { in: LIFETIMES_IN_MONTHS }, on: :self_service
  validate :name_unique_among_active_tokens, on: :self_service
  validate :active_tokens_limit_not_reached, on: :self_service
  validate :authorization_request_open_to_token_creation, on: :self_service

  def self.build_for_self_service(authorization_request, creator:, name:, lifetime_in_months:, allowed_ips_text: nil)
    authorization_request.tokens.new(
      default_create_params.merge(
        allowed_ips_text:,
        creator:,
        name: name.to_s.strip,
        lifetime_in_months:,
        exp: lifetime_in_months.to_i.months.from_now.to_i,
        scopes: authorization_request.scopes
      )
    )
  end

  def access_scopes
    scopes.pluck(:code)
  end

  def used?
    return true if used

    result = !access_logs.where(timestamp: 30.days.ago..).limit(1).empty? || !access_logs.limit(1).empty?
    update(used: true) if result
    result
  end

  delegate :api, to: :authorization_request

  def self.default_create_params
    {
      iat: Time.zone.now.to_i,
      version: '1.0',
      exp: 18.months.from_now.to_i,
      extra_info: {}
    }
  end

  delegate :intitule, :siret, to: :authorization_request

  def extra_info
    super || {}
  end

  def legacy_token?
    extra_info['legacy_token_id'].present?
  end

  def legacy_token_migrated?
    extra_info['legacy_token_migrated'].present?
  end

  def blacklisted_later?
    blacklisted_at.present? &&
      blacklisted_at > Time.zone.now
  end

  def end_timestamp
    return blacklisted_at.to_i if blacklisted_at.present?

    exp
  end

  def revoke!
    update!(blacklisted_at: Time.zone.now)
  end

  private

  def allowed_ips_envelope
    Array(authorization_request&.security_settings&.allowed_ips)
  end

  def allowed_ips_envelope_error
    :outside_authorization_request_range
  end

  def name_unique_among_active_tokens
    return if authorization_request.nil? || name.blank?
    return unless authorization_request.tokens.active.where.not(id:).exists?(name:)

    errors.add(:name, :taken)
  end

  def authorization_request_open_to_token_creation
    return if authorization_request.nil? || authorization_request.eligible_for_token_creation?

    errors.add(:base, :authorization_request_closed)
  end

  def active_tokens_limit_not_reached
    return if authorization_request.nil?
    return if authorization_request.tokens.active.where.not(id:).count < AuthorizationRequest::MAX_ACTIVE_TOKENS

    errors.add(:base, :active_tokens_limit_reached, count: AuthorizationRequest::MAX_ACTIVE_TOKENS)
  end

  def jwt_data
    payload = {
      uid: id,
      jti: id,
      scopes:,
      sub: intitule,
      extra_info:,
      iat:,
      version:
    }
    # JWT is by design expired if exp is null
    payload[:exp] = exp unless exp.nil?
    payload
  end
end
