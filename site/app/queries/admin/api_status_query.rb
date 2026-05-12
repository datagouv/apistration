class Admin::ApiStatusQuery
  def initialize(filter)
    @filter = filter
  end

  # card 420
  def total_calls
    scoped.count
  end

  # card 419
  def unique_calls
    scoped.select("DISTINCT COALESCE(params->>'hashed_params', path)").count
  end

  # card 415
  def cached_calls
    scoped.where(cached: true).count
  end

  # card 422
  def calls_vs_unique_evolution
    scoped
      .select(
        "date_trunc('#{filter.pg_interval_unit}', timestamp) AS period",
        'COUNT(*) AS total',
        "COUNT(DISTINCT COALESCE(params->>'hashed_params', path)) AS unique_count"
      )
      .group("date_trunc('#{filter.pg_interval_unit}', timestamp)")
      .order(:period)
      .map { |r| { bucket: r.period, total: r.total.to_i, unique: r.unique_count.to_i } }
  end

  # card 421
  def cached_evolution
    scoped
      .where(cached: true)
      .select(
        "date_trunc('#{filter.pg_interval_unit}', timestamp) AS period",
        'COUNT(*) AS total'
      )
      .group("date_trunc('#{filter.pg_interval_unit}', timestamp)")
      .order(:period)
      .map { |r| { bucket: r.period, total: r.total.to_i } }
  end

  # card 423
  def duration_evolution
    scoped
      .where("status IN ('200', '404')")
      .select(
        "date_trunc('#{filter.pg_interval_unit}', timestamp) AS period",
        'ROUND(AVG(duration::numeric), 2) AS avg_dur'
      )
      .group("date_trunc('#{filter.pg_interval_unit}', timestamp)")
      .order(:period)
      .map { |r| { bucket: r.period, value: r.avg_dur&.to_f || 0 } }
  end

  # card 424
  def http_code_breakdown
    scoped
      .select('status', 'COUNT(*) AS total')
      .group(:status)
      .order(total: :desc)
      .map { |r| { label: r.status, value: r.total.to_i } }
  end

  # card 478
  def api_list
    scope = ControllerName.all
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope.order(controller: :desc).pluck(:controller)
  end

  private

  attr_reader :filter

  def scoped # rubocop:disable Metrics/AbcSize
    scope = AccessLog
      .where(timestamp: filter.date_from.beginning_of_day..filter.date_to.end_of_day)
      .where("status NOT IN ('401', '403')")
      .where.not(controller: excluded_controllers)

    scope = scope.where(controller: filter.api) if filter.api.present?
    scope = scope.where("split_part(controller, '/', 1) = ?", filter.domaine_prefix) if filter.api.blank? && filter.domaine?
    scope
  end

  def excluded_controllers
    %w[uptime ping errors api_particulier/introspect api_entreprise/proxied_files
       api_particulier/ping_providers api_entreprise/ping_providers
       api_entreprise/inpi_proxy api_particulier/france_connect_jwks]
  end
end
