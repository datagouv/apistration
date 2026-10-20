class Admin::KpiQuery
  def initialize(filter)
    @filter = filter
  end

  # card 480
  def total_calls
    filtered(ConsumptionSummary.where(date: period)).sum(:appels_totaux).to_i
  end

  # card 480
  def previous_total_calls
    filtered(ConsumptionSummary.where(date: previous_period)).sum(:appels_totaux).to_i
  end

  # card 538
  def unique_calls
    filtered(ConsumptionSummary.where(date: period)).sum(:appels_uniques).to_i
  end

  # card 538
  def previous_unique_calls
    filtered(ConsumptionSummary.where(date: previous_period)).sum(:appels_uniques).to_i
  end

  # card 481
  def calls_by_period
    series(:appels_totaux)
  end

  # card 537
  def unique_calls_by_period
    series(:appels_uniques)
  end

  # card 482
  def error_breakdown
    success, not_found, total = scoped.pick(coalesce_sum(:appels_succes), coalesce_sum(:appels_echecs), coalesce_sum(:appels_totaux)).map(&:to_i)

    { 'Succès' => success, 'Non trouvés' => not_found, 'Autre' => total - success - not_found }
  end

  # card 29
  def kpi1_series
    weekly(KpiView::Kpi1, :entreprises)
  end

  # card 30
  def kpi2_series
    weekly(KpiView::Kpi2, :distinct_hits)
  end

  # card 553
  def kpi3_series
    weekly(KpiView::Kpi3, :entreprises)
  end

  # card 597
  def top_variations
    current = consumption_by_source(period)
    previous = consumption_by_source(previous_period)

    (current.keys | previous.keys)
      .map { |key| variation_row(key, current.fetch(key, 0), previous.fetch(key, 0)) }
      .sort_by { |row| -row[:variation_brute].abs }
      .first(10)
  end

  private

  attr_reader :filter

  def period
    filter.date_from..last_complete_day
  end

  def previous_period
    length = (last_complete_day - filter.date_from).to_i + 1
    (filter.date_from - length.days)..(filter.date_from - 1.day)
  end

  def last_complete_day
    [filter.date_to, Date.yesterday].min
  end

  def scoped
    filtered(ConsumptionSummary.where(date: filter.date_from..filter.date_to))
  end

  def filtered(scope)
    by_api(scope).where({ email_demandeur: filter.email, source_id: filter.external_id, demarche: filter.demarche }.compact)
  end

  def by_api(scope)
    scope = scope.where("split_part(#{ConsumptionSummary.table_name}.api, '/', 1) = ?", filter.domaine_prefix) if filter.domaine?
    scope = scope.where(api: filter.api) if filter.api.present?
    scope
  end

  def series(column)
    scoped
      .group(date_trunc_sql)
      .order(Arel.sql(date_trunc_sql))
      .pluck(Arel.sql(date_trunc_sql), coalesce_sum(column))
      .map { |bucket, total| { bucket:, total: total.to_i } }
  end

  def weekly(view, column)
    view.order(:semaine).pluck(:semaine, column).map { |week, value| { bucket: week, value: value.to_i } }
  end

  def consumption_by_source(dates)
    by_api(ConsumptionSummary.where(date: dates))
      .joins(demandeur_join)
      .group(:source_id, 'authorization_requests.api', 'users.email')
      .pluck(:source_id, 'authorization_requests.api', 'users.email', coalesce_sum(:appels_totaux))
      .to_h { |source_id, domaine, email, total| [[source_id, domaine, email], total.to_i] }
  end

  def demandeur_join
    <<~SQL.squish
      LEFT JOIN authorization_requests ON authorization_requests.external_id = #{ConsumptionSummary.table_name}.source_id
      LEFT JOIN user_authorization_request_roles
        ON user_authorization_request_roles.authorization_request_id = authorization_requests.id
        AND user_authorization_request_roles.role = 'demandeur'
      LEFT JOIN users ON users.id = user_authorization_request_roles.user_id
    SQL
  end

  def variation_row((source_id, domaine, email), current, previous)
    variation = if previous.zero?
                  current.positive? ? 100.0 : 0.0
                else
                  ((current - previous) * 100.0 / previous).round(2)
                end

    { source_id:, domaine:, email:, current:, previous:, variation:, variation_brute: current - previous }
  end

  def date_trunc_sql
    "date_trunc('#{filter.pg_interval_unit}', date)"
  end

  def coalesce_sum(column)
    Arel::Nodes::NamedFunction.new('COALESCE', [ConsumptionSummary.arel_table[column].sum, Arel::Nodes.build_quoted(0)])
  end
end
