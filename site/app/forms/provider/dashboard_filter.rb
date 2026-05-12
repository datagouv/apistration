class Provider::DashboardFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTERVALS = %w[jour semaine mois].freeze

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

  attr_reader :provider, :api

  attribute :date_from, :date
  attribute :date_to, :date
  attribute :routes
  attribute :interval, :string, default: 'jour'

  validates :interval, inclusion: { in: INTERVALS }
  validate :date_from_before_date_to

  def initialize(provider, api, attributes = {}) # rubocop:disable Metrics/AbcSize
    @provider = provider
    @api = api
    attrs = attributes.to_h.symbolize_keys
    @routes_submitted = attrs.key?(:routes)
    super(attrs)
    self.date_from ||= 7.days.ago.to_date
    self.date_to ||= Date.current
    self.routes = Array(routes).compact_blank
    self.interval = 'jour' unless INTERVALS.include?(interval)
  end

  def routes_submitted? = @routes_submitted

  def matches_preset?(key)
    from, to = self.class.date_presets[key]
    from == date_from && to == date_to
  end

  def route_checked?(value)
    return true unless routes_submitted?

    routes.include?(value)
  end

  def date_range
    date_from.beginning_of_day..date_to.end_of_day
  end

  def pg_interval_unit
    INTERVAL_TO_PG_UNIT.fetch(interval, 'day')
  end

  def endpoint_options
    @endpoint_options ||= provider_endpoints
      .reject(&:deprecated?)
      .filter_map { |endpoint| [endpoint.controller, endpoint.title] if endpoint.controller.present? }
      .uniq(&:first)
      .sort_by(&:second)
  end

  def provider_endpoints
    @provider_endpoints ||= begin
      all = endpoint_klass.all
      provider.uid == 'all' ? all : all.select { |endpoint| endpoint.provider_uids.to_a.include?(provider.uid) }
    end
  end

  private

  def endpoint_klass
    Kernel.const_get("API#{api.to_s.classify}::Endpoint")
  end

  def date_from_before_date_to
    return if date_from.blank? || date_to.blank?

    errors.add(:date_to, :must_be_after_date_from) if date_to < date_from
  end
end
