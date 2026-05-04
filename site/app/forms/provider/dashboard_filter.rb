class Provider::DashboardFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTERVALS = %w[jour semaine mois].freeze

  INTERVAL_TO_PG_UNIT = {
    'jour' => 'day',
    'semaine' => 'week',
    'mois' => 'month'
  }.freeze

  attribute :date_from, :date
  attribute :date_to, :date
  attribute :routes
  attribute :interval, :string, default: 'jour'

  validates :interval, inclusion: { in: INTERVALS }
  validate :date_from_before_date_to

  def initialize(provider, attributes = {})
    @provider = provider
    super(attributes.to_h.symbolize_keys)
    self.date_from ||= 7.days.ago.to_date
    self.date_to ||= Date.current
    self.routes = Array(routes).compact_blank
    self.interval = 'jour' unless INTERVALS.include?(interval)
  end

  def date_range
    date_from.beginning_of_day..date_to.end_of_day
  end

  def pg_interval_unit
    INTERVAL_TO_PG_UNIT.fetch(interval, 'day')
  end

  # Une checkbox par fiche déclarant ce provider dans `provider_uids`.
  # Valeur = controller Rails (clé technique stable, jointure directe avec
  # `consumption_summary.api`), label = titre OpenAPI de la fiche.
  def endpoint_options
    @endpoint_options ||= provider_endpoints
      .reject(&:deprecated?)
      .filter_map { |endpoint| [endpoint.controller, endpoint.title] if endpoint.controller.present? }
      .uniq(&:first)
      .sort_by(&:second)
  end

  private

  attr_reader :provider

  def provider_endpoints
    @provider_endpoints ||= endpoint_klass.all.select { |endpoint| endpoint.provider_uids.to_a.include?(provider.uid) }
  rescue NameError
    []
  end

  def endpoint_klass
    Kernel.const_get("#{provider.class.name.split('::').first}::Endpoint")
  end

  def date_from_before_date_to
    return if date_from.blank? || date_to.blank?

    errors.add(:date_to, :must_be_after_date_from) if date_to < date_from
  end
end
