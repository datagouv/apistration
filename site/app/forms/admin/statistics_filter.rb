class Admin::StatisticsFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTERVALS = %w[jour semaine mois].freeze
  DOMAINES = %w[entreprise particulier].freeze
  UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i

  INTERVAL_TO_PG_UNIT = {
    'jour' => 'day',
    'semaine' => 'week',
    'mois' => 'month'
  }.freeze

  def self.date_presets(today: Date.current)
    {
      '7j' => [today - 7.days, today - 1.day],
      '1m' => [today - 1.month, today],
      '3m' => [today - 3.months, today],
      '6m' => [today - 6.months, today],
      '12m' => [today - 12.months, today],
      'last_year' => [today.last_year.beginning_of_year, today.last_year.end_of_year]
    }
  end

  attribute :date_from, :date
  attribute :date_to, :date
  attribute :interval, :string, default: 'jour'
  attribute :domaine, :string
  attribute :api, :string
  attribute :email, :string
  attribute :external_id, :string
  attribute :token_id, :string
  attribute :demarche, :string
  attribute :france_connect_client_id, :string
  attribute :status, :string

  validates :interval, inclusion: { in: INTERVALS }
  validate :date_from_before_date_to

  def initialize(attributes = {}, default_dates = nil)
    super(attributes.to_h.symbolize_keys.compact_blank)
    assign_default_dates(*default_dates || self.class.date_presets['7j'])
    self.interval = 'jour' unless INTERVALS.include?(interval)
    self.domaine = nil unless DOMAINES.include?(domaine)
  end

  def matches_preset?(key)
    from, to = self.class.date_presets[key]
    from == date_from && to == date_to
  end

  def date_range
    date_from.beginning_of_day..date_to.end_of_day
  end

  def pg_interval_unit
    INTERVAL_TO_PG_UNIT.fetch(interval, 'day')
  end

  def domaine_prefix
    return nil if domaine.blank?

    "api_#{domaine}"
  end

  def domaine?
    domaine.present?
  end

  def valid_token_id?
    token_id.to_s.match?(UUID_FORMAT)
  end

  def habilitation_criteria?
    [email, external_id, token_id, demarche].any?(&:present?)
  end

  def matching_habilitations(scope = AuthorizationRequest.all)
    scope = scope.where({ api: domaine, external_id:, demarche: }.compact)
    scope = scope.where(tokens: { id: valid_token_id? ? token_id : nil }) if token_id
    scope = scope.where(id: habilitations_of_email) if email
    scope
  end

  private

  def assign_default_dates(default_from, default_to)
    self.date_from ||= default_from
    self.date_to ||= default_to
  end

  def habilitations_of_email
    UserAuthorizationRequestRole.joins(:user).where(users: { email: }).select(:authorization_request_id)
  end

  def date_from_before_date_to
    return if date_from.blank? || date_to.blank?

    errors.add(:date_to, :must_be_after_date_from) if date_to < date_from
  end
end
