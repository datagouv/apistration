class Admin::StatisticsFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTERVALS = %w[jour semaine mois].freeze
  DOMAINES = %w[entreprise particulier].freeze

  INTERVAL_TO_PG_UNIT = {
    'jour' => 'day',
    'semaine' => 'week',
    'mois' => 'month'
  }.freeze

  def self.date_presets(today: Date.current)
    {
      '1m' => [today - 1.month, today],
      '3m' => [today - 3.months, today],
      '6m' => [today - 6.months, today],
      '12m' => [today - 12.months, today],
      'last_year' => [today.last_year.beginning_of_year, today.last_year.end_of_year]
    }
  end

  attribute :date_from, :date
  attribute :date_to, :date
  attribute :interval, :string, default: 'mois'
  attribute :domaine, :string
  attribute :api, :string
  attribute :email, :string
  attribute :external_id, :string
  attribute :token_id, :string

  validates :interval, inclusion: { in: INTERVALS }
  validate :date_from_before_date_to

  def initialize(attributes = {})
    attrs = attributes.to_h.symbolize_keys
    super(attrs)
    self.date_from ||= 3.months.ago.to_date
    self.date_to ||= Date.current
    self.interval = 'mois' unless INTERVALS.include?(interval)
  end

  def matches_preset?(key)
    from, to = self.class.date_presets[key]
    from == date_from && to == date_to
  end

  def pg_interval_unit
    INTERVAL_TO_PG_UNIT.fetch(interval, 'month')
  end

  def domaine_prefix
    return nil if domaine.blank?

    "api_#{domaine}"
  end

  def domaine?
    domaine.present?
  end

  private

  def date_from_before_date_to
    return if date_from.blank? || date_to.blank?

    errors.add(:date_to, :must_be_after_date_from) if date_to < date_from
  end
end
